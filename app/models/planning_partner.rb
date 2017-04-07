#------------------------------------------------------------------------------
#
# PlanningPartner
#
# Represents an organization that has read-only access to other transit agency assets
# and reports to a single grantor
#
#------------------------------------------------------------------------------
class PlanningPartner < FtaAgency
  
  #------------------------------------------------------------------------------
  # Callbacks 
  #------------------------------------------------------------------------------
  after_initialize :set_defaults
  
  #------------------------------------------------------------------------------
  # Associations 
  #------------------------------------------------------------------------------

  # Each PlanningPartner has a single Grantor organization
  belongs_to  :grantor,             :class_name => "Grantor",         :foreign_key => "grantor_id"

  # Each PlanningPartner has a list of grantees who report to them
  has_and_belongs_to_many :transit_operators, :class_name => "TransitOperator", :join_table => 'planning_partners_organizations', :association_foreign_key => 'organization_id'
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  # set the default scope
  default_scope { where(:organization_type_id => OrganizationType.find_by_class_name(self.name).id) }
  
  # List of allowable form param hash keys  
  FORM_PARAMS = [
    :grantor_id,
    :transit_operator_ids => []
  ]

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
      
  def self.allowable_params
    FORM_PARAMS
  end

  def self.createable?
    true
  end
            
  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  def updates_after_create
    return
  end

  # returns the count of assets of the given type. If no type is selected it returns the total
  # number of assets
  def asset_count(asset_type = nil) 
    0
  end
  
  #------------------------------------------------------------------------------
  # Overrides
  #------------------------------------------------------------------------------  
  # The policy is provided by the grantor organization that the agency reports to
  def get_policies
    grantor.get_policies
  end
  def get_policy
    grantor.get_policy
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
    self.license_holder = self.license_holder.nil? ? false : self.license_holder
  end    
  
end
      