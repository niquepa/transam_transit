class ServiceVehicle < TransamAssetRecord
  acts_as :transit_asset, as: :transit_assetible
  actable as: :service_vehiclible

  before_destroy { fta_mode_types.clear }
  after_save :check_fleet

  belongs_to :chassis
  belongs_to :fuel_type
  belongs_to :dual_fuel_type
  belongs_to :ramp_manufacturer

  # Each vehicle has a set (0 or more) of fta mode type
  has_many                  :assets_fta_mode_types,       :foreign_key => :transit_asset_id,    :join_table => :assets_fta_mode_types
  has_and_belongs_to_many   :fta_mode_types,              :foreign_key => :transit_asset_id,    :join_table => :assets_fta_mode_types

  # These associations support the separation of mode types into primary and secondary.
  has_one :primary_assets_fta_mode_type, -> { is_primary },
          class_name: 'AssetsFtaModeType', :foreign_key => :transit_asset_id
  has_one :primary_fta_mode_type, through: :primary_assets_fta_mode_type, source: :fta_mode_type

  # These associations support the separation of mode types into primary and secondary.
  has_many :secondary_assets_fta_mode_types, -> { is_not_primary }, class_name: 'AssetsFtaModeType', :foreign_key => :transit_asset_id,    :join_table => :assets_fta_service_types
  has_many :secondary_fta_mode_types, through: :secondary_assets_fta_mode_types, source: :fta_mode_type,    :join_table => :assets_fta_mode_types


  # each vehicle has zero or more operations update events
  has_many   :operations_updates, -> {where :asset_event_type_id => OperationsUpdateEvent.asset_event_type.id }, :class_name => "OperationsUpdateEvent", :foreign_key => "transam_asset_id"

  # each vehicle has zero or more operations update events
  has_many   :vehicle_usage_updates,      -> {where :asset_event_type_id => VehicleUsageUpdateEvent.asset_event_type.id }, :class_name => "VehicleUsageUpdateEvent",  :foreign_key => "transam_asset_id"

  # each asset has zero or more storage method updates. Only for rolling stock assets.
  has_many   :storage_method_updates, -> {where :asset_event_type_id => StorageMethodUpdateEvent.asset_event_type.id }, :class_name => "StorageMethodUpdateEvent", :foreign_key => "transam_asset_id"

  # each asset has zero or more usage codes updates. Only for vehicle assets.
  has_many   :usage_codes_updates, -> {where :asset_event_type_id => UsageCodesUpdateEvent.asset_event_type.id }, :foreign_key => :transam_asset_id, :class_name => "UsageCodesUpdateEvent"

  # each asset has zero or more mileage updates. Only for vehicle assets.
  has_many    :mileage_updates, -> {where :asset_event_type_id => MileageUpdateEvent.asset_event_type.id }, :foreign_key => :transam_asset_id, :class_name => "MileageUpdateEvent"

has_many :assets_asset_fleets, :foreign_key => :service_vehicle_id

has_and_belongs_to_many :asset_fleets, :through => :assets_asset_fleets, :join_table => 'assets_asset_fleets', :foreign_key => :service_vehicle_id

  FORM_PARAMS = [
    :serial_number,
    :chassis_id,
    :other_chassis,
    :fuel_type_id,
    :dual_fuel_type_id,
    :other_fuel_type,
    :license_plate,
    :vehicle_length,
    :vehicle_length_unit,
    :gross_vehicle_weight,
    :gross_vehicle_weight_unit,
    :seating_capacity,
    :wheelchair_capacity,
    :ramp_manufacturer_id,
    :other_ramp_manufacturer,
    :ada_accessible
  ]

  def primary_fta_mode_type_id
    primary_fta_mode_type.try(:id)
  end

  # Override setters for primary_fta_mode_type for HABTM association
  def primary_fta_mode_type_id=(num)
    build_primary_assets_fta_mode_type(fta_mode_type_id: num, is_primary: true)
  end

  def ntd_id
    Asset.get_typed_asset(asset).asset_fleets.first.try(:ntd_id) if asset # currently temporarily looks at old asset
  end

  def reported_mileage
    mileage_updates.last.try(:current_mileage)
  end

  def fiscal_year_mileage(fy_year=nil)
    fy_year = current_fiscal_year_year if fy_year.nil?

    last_date = start_of_fiscal_year(fy_year+1) - 1.day
    mileage_updates.where(event_date: last_date).last.try(:current_mileage)
  end

  def expected_useful_miles
    # TODO might need to update this for used miles.
    policy_analyzer.get_min_service_life_miles
  end

  # link to old asset if no instance method in chain
  def method_missing(method, *args, &block)
    if !self_respond_to?(method) && acting_as.respond_to?(method)
      acting_as.send(method, *args, &block)
    elsif !self_respond_to?(method) && typed_asset.respond_to?(method)
      puts "You are calling the old asset for this method"
      Rails.logger.warn "You are calling the old asset for this method"
      typed_asset.send(method, *args, &block)
    else
      super
    end
  end

protected

  def check_fleet
    asset_fleets.each do |fleet|
      fleet_type = fleet.asset_fleet_type

      # only need to check on an asset which is still valid in fleet
      if self.assets_asset_fleets.find_by(asset_fleet: fleet).active

        if fleet.active_assets.count == 1 && fleet.active_assets.first.object_key == self.object_key # if the last valid asset in fleet
          # check all other assets to see if they now match the last active fleet whose changes are now the fleets grouped values
          fleet.assets.where.not(id: self.id).each do |asset|
            typed_asset = Asset.get_typed_asset(asset)
            if asset.attributes.slice(*fleet_type.standard_group_by_fields) == self.attributes.slice(*fleet_type.standard_group_by_fields)
              is_valid = true
              fleet_type.custom_group_by_fields.each do |field|
                if typed_asset.send(field) != self.send(field)
                  is_valid = false
                  break
                end
              end

              AssetsAssetFleet.find_by(asset: asset, asset_fleet: fleet).update(active: is_valid)
            end
          end
        else
          if (self.previous_changes.keys & fleet_type.standard_group_by_fields).count > 0
            AssetsAssetFleet.find_by(asset: self, asset_fleet: fleet).update(active: false)
          else # check custom fields
            asset_to_follow = Asset.get_typed_asset(fleet.active_assets.where.not(id: self.id).first)

            fleet_type.custom_group_by_fields.each do |field|
              if asset_to_follow.send(field) != self.send(field)
                AssetsAssetFleet.find_by(asset: self, asset_fleet: fleet).update(active: false)
                break
              end
            end
          end
        end
      end
    end

    return true
  end

end
