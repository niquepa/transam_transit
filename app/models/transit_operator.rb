#------------------------------------------------------------------------------
#
# TransitOperator
#
# Represents an transit operator in TransAM Transit
#
#------------------------------------------------------------------------------
class TransitOperator < FtaAgency

  # Include the fiscal year mixin
  include FiscalYear

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize :set_defaults

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------

  # Each Transit Operator has a single Grantor organization
  belongs_to  :grantor,           :class_name => "Grantor",               :foreign_key => "grantor_id"

  # Every Transit Operator has one or more service provider types
  has_and_belongs_to_many  :service_provider_types, :foreign_key => 'organization_id'

  # Each Transit Operator has a single Planning Organization
  belongs_to  :planning_partner,  :class_name => "PlanningOrganization",  :foreign_key => "planning_partner_id"

  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  # set the default scope
  default_scope { where(:organization_type_id => OrganizationType.find_by_class_name(self.name).id) }

  # List of allowable form param hash keys
  FORM_PARAMS = [
    :grantor_id,
    :planning_partner_id,
    :service_provider_type_ids => []
  ]

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  def self.allowable_params
    FORM_PARAMS
  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------


  #------------------------------------------------------------------------------
  # Overrides
  #------------------------------------------------------------------------------

  def get_policy
    unless policies.empty?
      # get the current policy if one has been created and set as current
      policy = policies.current.first
    end
    return policy.nil? ? grantor.get_policy : policy
  end

  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new organization
  def set_defaults
    super
    self.organization_type ||= OrganizationType.find_by_class_name(self.name).first
  end

end
