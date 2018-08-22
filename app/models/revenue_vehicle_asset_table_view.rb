class RevenueVehicleAssetTableView  < ActiveRecord::Base

  def readonly?
    true
  end

  #These associations are to more quickly support the access of recent asset events for the model
  belongs_to :revenue_vehicle
  belongs_to :asset_group, class_name: 'AssetGroup', :foreign_key => :asset_group_id
  belongs_to :asset_fleet, class_name: 'AssetFleet', :foreign_key => :asset_fleet_id
  belongs_to :most_recent_asset_event, class_name: 'AssetEvent', :foreign_key => :id
  belongs_to :condition_event, class_name: 'ConditionUpdateEvent', :foreign_key => :condition_event_id
  belongs_to :service_status_event, class_name: 'ServiceStatusUpdateEvent', :foreign_key => :service_status_event_id
  belongs_to :rebuild_event, class_name: 'RehabilitationUpdateEvent', :foreign_key => :rebuild_event_id
  belongs_to :mileage_event, class_name: 'MileageUpdateEvent', :foreign_key => :mileage_event_id
  belongs_to :early_replacement_status_event, class_name: 'ReplacementStatusUpdateEvent', :foreign_key => :early_replacement_status_event_id



  def self.get_default_table_headers()
    ["Asset ID", "Organization", "VIN", "Manufacturer", "Model", "Year", "Class",
     "Type", "Status", "ESL", "Last Life Cycle Action", "Life Cycle Action Date"]
  end

  def self.get_all_table_headers()
    ["Asset ID", "Organization", "VIN", "Manufacturer", "Model", "Year", "Class", "Subtype", "Status", "ESL",
     "Last Life Cycle Action", "Life Cycle Action Date", "External ID", "ESL Category", "Chassis",
     "Fuel Type", "Funding Program (largest %)", "Operator", "Plate #", "Primary Mode", "Direct Capital Responsibility",
     "Capital Responsibility %", "Asset Group", "Service Life - Current", "TERM Condition", "TERM Rating", "NTD ID",
     "Date of Condition Assessment", "Odometer Reading", "Date of Odometer Reading", "Replace / Rehab Policy (ESL)",
     "TAM Policy (ULB)", "ESL - Adjusted", "ULB - Adjusted", "Rebuild / Rehab Type", "Date of Rebuild / Rehab", "Location",
     "Current Book Value", "Replacement Status", "Replacement Policy Year", "Replacement Actual Year", "Scheduled Replacement Cost",
     "In Service Date", "Purchase Cost"]
  end

end