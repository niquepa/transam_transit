class Infrastructure < TransamAssetRecord

  acts_as :transit_asset, as: :transit_assetible

  belongs_to :infrastructure_segment_unit_type
  belongs_to :infrastructure_chain_type
  belongs_to :infrastructure_segment_type
  belongs_to :infrastructure_division
  belongs_to :infrastructure_subdivision
  belongs_to :infrastructure_track
  belongs_to :infrastructure_gauge_type
  belongs_to :infrastructure_reference_rail
  belongs_to :land_ownership_organization, class_name: 'Organization'
  belongs_to :shared_capital_responsibility_organization, class_name: 'Organization'

  # These associations support the separation of mode types into primary and secondary.
  has_one :primary_assets_fta_mode_type, -> { is_primary },
          class_name: 'AssetsFtaModeType', :foreign_key => :transam_asset_id
  has_one :primary_fta_mode_type, through: :primary_assets_fta_mode_type, source: :fta_mode_type

  # These associations support the separation of service types into primary and secondary.
  has_one :primary_assets_fta_service_type, -> { is_primary },
          class_name: 'AssetsFtaServiceType', :foreign_key => :transam_asset_id
  has_one :primary_fta_service_type, through: :primary_assets_fta_service_type, source: :fta_service_type



  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------
  validates :description, presence: true
  validates :infrastructure_segment_type_id, presence: true
  validates :from_line, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name != 'Lat / Long'}
  validates :to_line, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name != 'Lat / Long'}
  validates :from_segment, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name != 'Lat / Long'}
  validates :to_segment, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name != 'Lat / Long'}
  validates :segment_unit, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name == 'Marker Posts'}
  validates :infrastructure_chain_type_id, presence: true, if: Proc.new{|a| a.infrastructure_segment_type.name == 'Chaining'}
  validates :standing_capacity, presence: true
  validates :infrastructure_division_id, presence: true
  validates :infrastructure_subdivision_id, presence: true
  validates :infrastructure_track_id, presence: true
  validates :full_service_speed, presence: true, numericality: { greater_than: 0 }
  validates :full_service_speed_unit, presence: true

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  FORM_PARAMS = [
      :from_line,
      :to_line,
      :infrastructure_segment_unit_type_id,
      :from_segment,
      :to_segment,
      :segment_unit,
      :from_location_name,
      :to_location_name,
      :infrastructure_chain_type_id,
      :relative_location,
      :relative_location_unit,
      :relative_location_direction,
      :infrastructure_segment_type_id,
      :infrastructure_division_id,
      :infrastructure_subdivision_id,
      :infrastructure_track_id,
      :direction,
      :infrastructure_gauge_type_id,
      :gauge,
      :gauge_unit,
      :infrastructure_reference_rail_id,
      :track_gradient_pcnt,
      :track_gradient_degree,
      :track_gradient,
      :track_gradient_unit,
      :horizontal_alignment,
      :horizontal_alignment_unit,
      :vertical_alignment,
      :vertical_alignment_unit,
      :crosslevel,
      :crosslevel_unit,
      :warp_parameter,
      :warp_parameter_unit,
      :track_curvature,
      :track_curvature_unit,
      :track_curvature_degree,
      :cant,
      :cant_unit,
      :cant_gradient,
      :cant_gradient_unit,
      :full_service_speed,
      :full_service_speed_unit,
      :land_ownership_organization_id,
      :other_land_ownership_organization_id,
      :shared_capital_responsibility_organization_id,
      :primary_fta_mode_type_id,
      :primary_fta_service_type_id
  ]

  def dup
    super.tap do |new_asset|
      new_asset.transit_asset = self.transit_asset.dup
      new_asset.assets_fta_mode_types = self.assets_fta_mode_types
      new_asset.assets_fta_service_types = self.assets_fta_service_types
    end
  end

  def primary_fta_mode_type_id
    primary_fta_mode_type.try(:id)
  end

  # Override setters for primary_fta_mode_type for HABTM association
  def primary_fta_mode_type_id=(num)
    build_primary_assets_fta_mode_type(fta_mode_type_id: num, is_primary: true)
  end

  def primary_fta_service_type_id
    primary_fta_service_type.try(:id)
  end

  # Override setters for primary_fta_mode_type for HABTM association
  def primary_fta_service_type_id=(num)
    build_primary_assets_fta_service_type(fta_service_type_id: num, is_primary: true)
  end

end
