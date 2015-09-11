#------------------------------------------------------------------------------
#
# FtaFacility
#
# Abstract class that adds fta characteristics to a Structure asset
#
#------------------------------------------------------------------------------
class FtaFacility < Structure

  # Callbacks
  after_initialize :set_defaults
  after_save       :require_at_least_one_fta_mode_type     # validate model for HABTM relationships

  # Clean up any HABTM associations before the asset is destroyed
  before_destroy { :clean_habtm_relationships }

  #------------------------------------------------------------------------------
  # Associations common to all fta facilites
  #------------------------------------------------------------------------------

  # Each facility has a set (0 or more) of fta mode type. This is the primary mode
  # serviced at the facility
  has_and_belongs_to_many   :fta_mode_types,              :foreign_key => :asset_id

  # Each facility must identify the FTA Facility type for NTD reporting
  belongs_to  :fta_facility_type

  #------------------------------------------------------------------------------
  # Validations common to all fta facilites
  #------------------------------------------------------------------------------
  validates   :fta_facility_type,   :presence => :true
  validates   :pcnt_capital_responsibility, :numericality => {:only_integer => :true,   :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  def self.allowable_params
    [
      :pcnt_capital_responsibility,
      :fta_facility_type_id,
      :primary_fta_mode_type_id,
      :fta_mode_type_ids => []
    ]
  end


  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # Render the asset as a JSON object -- overrides the default json encoding
  def as_json(options={})
    super.merge(
    {
      :fta_mode_types => self.fta_mode_types,
      :fta_facility_type_id => self.fta_facility_type.present? ? self.fta_facility_type.to_s : nil,
      :pcnt_capital_responsibility => self.pcnt_capital_responsibility
    })
  end

  def primary_fta_mode_type_id
    self.fta_mode_types.first.id unless self.fta_mode_types.first.nil?
  end

  # Override setters for primary_fta_mode_type for HABTM association
  def primary_fta_mode_type_id=(num)
    self.fta_mode_type_ids=([num])
  end

  def searchable_fields
    a = []
    a << super
    a += [:fta_facility_type]
    a.flatten
  end

  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  def clean_habtm_relationships
    fta_mode_types.clear
  end

  def require_at_least_one_fta_mode_type
    if fta_mode_types.count == 0
      errors.add(:fta_mode_types, "must be selected.")
      return false
    end
  end

  # Set resonable defaults for a new fta vehicle
  def set_defaults
    super
    self.pcnt_capital_responsibility ||= 100
  end

end
