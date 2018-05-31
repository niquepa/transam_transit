#-------------------------------------------------------------------------------
#
# Asset Tag
#
# Map relation that maps an asset to a user as part of a tag.
#
#-------------------------------------------------------------------------------
class AssetsDistrict < ActiveRecord::Base
  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Associations
  #-----------------------------------------------------------------------------

  belongs_to  :asset
  belongs_to  :transam_asset

  belongs_to  :district

  #-----------------------------------------------------------------------------
  # Scopes
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------


  #-----------------------------------------------------------------------------
  # Constants
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #-----------------------------------------------------------------------------
  protected

end
