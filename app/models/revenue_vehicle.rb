class RevenueVehicle < TransamAssetRecord
  acts_as :service_vehicle, as: :service_vehiclible

  before_destroy do
    fta_service_types.clear
    vehicle_features.clear
  end

  belongs_to :esl_category
  belongs_to :fta_funding_type
  belongs_to :fta_ownership_type

  # Each vehicle has a set (0 or more) of vehicle features
  has_and_belongs_to_many   :vehicle_features,    :foreign_key => 'transit_asset_id',    :join_table => :assets_vehicle_features

  # Each vehicle has a set (0 or more) of fta service type
  has_many                  :assets_fta_service_types,       :foreign_key => :transit_asset_id,    :join_table => :assets_fta_service_types
  has_and_belongs_to_many   :fta_service_types,           :foreign_key => :transit_asset_id,    :join_table => :assets_fta_service_types

  # These associations support the separation of service types into primary and secondary.
  has_one :primary_assets_fta_service_type, -> { is_primary },
          class_name: 'AssetsFtaServiceType', :foreign_key => :transit_asset_id
  has_one :primary_fta_service_type, through: :primary_assets_fta_service_type, source: :fta_service_type

  # These associations support the separation of service types into primary and secondary.
  has_one :secondary_assets_fta_service_type, -> { is_not_primary },
          class_name: 'AssetsFtaServiceType', :foreign_key => :transit_asset_id
  has_one :secondary_fta_service_type, through: :secondary_assets_fta_service_type, source: :fta_service_type

  # These associations support the separation of mode types into primary and secondary.
  has_one :secondary_assets_fta_mode_type, -> { is_not_primary },
          class_name: 'AssetsFtaModeType', :foreign_key => :transit_asset_id
  has_one :secondary_fta_mode_type, through: :secondary_assets_fta_mode_type, source: :fta_mode_type

  FORM_PARAMS = [
      :esl_category_id,
      :standing_capacity,
      :fta_funding_type_id,
      :fta_ownership_type_id,
      :other_fta_ownership_type,
      :dedicated
  ]

  CLEANSABLE_FIELDS = [

  ]

  def dup
    super.tap do |new_asset|
      new_asset.fta_service_types = self.fta_service_types
      new_asset.vehicle_features = self.vehicle_features
      new_asset.service_vehicle = self.service_vehicle.dup
    end
  end

  def transfer new_organization_id
    transferred_asset = super(new_organization_id)
    transferred_asset.fta_ownership_type = nil
    transferred_asset.license_plate = nil
    transferred_asset.save(validate: false)

    return transferred_asset
  end



  def primary_fta_service_type_id
    primary_fta_service_type.try(:id)
  end

  # Override setters for primary_fta_mode_type for HABTM association
  def primary_fta_service_type_id=(num)
    build_primary_assets_fta_service_type(fta_service_type_id: num, is_primary: true)
  end

  def primary_fta_mode_service
    "#{primary_fta_mode_type.code} #{primary_fta_service_type.code}"
  end

  def secondary_fta_service_type_id
    secondary_fta_service_type.try(:id)
  end

  def secondary_fta_service_type_id=(value)
    if value.blank?
      self.secondary_assets_fta_service_type = nil
    else
      build_secondary_assets_fta_service_type(fta_service_type_id: value, is_primary: false)
    end
  end

  def secondary_fta_mode_type_id
    secondary_fta_mode_type.try(:id)
  end

  def secondary_fta_mode_type_id=(value)
    if value.blank?
      self.secondary_assets_fta_mode_type = nil
    else
      build_secondary_assets_fta_mode_type(fta_mode_type_id: value, is_primary: false)
    end
  end

  # link to old asset if no instance method in chain
  def method_missing(method, *args, &block)
    if !self_respond_to?(method) && acting_as.respond_to?(method)
      acting_as.send(method, *args, &block)
    elsif !self_respond_to?(method) && typed_asset.respond_to?(method)
      puts "You are calling the old asset for this method #{method}"
      Rails.logger.warn "You are calling the old asset for this method #{method}"
      typed_asset.send(method, *args, &block)
    else
      super
    end
  end

end
