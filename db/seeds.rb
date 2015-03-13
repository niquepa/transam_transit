#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'mysql2')
is_sqlite = (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

puts "======= Processing TransAM Transit Lookup Tables  ======="

#------------------------------------------------------------------------------
#
# Customized Lookup Tables
#
# These are the specific to TransAM Transit
#
#------------------------------------------------------------------------------

asset_types = [
  {:active => 1, :name => 'Revenue Vehicles',       :description => 'Revenue rolling stock',      :class_name => 'Vehicle',           :map_icon_name => "redIcon",      :display_icon_name => "fa fa-bus"},
  {:active => 1, :name => 'Stations/Stops/Terminals', :description => 'Stations/Stops/Terminals', :class_name => 'TransitFacility',   :map_icon_name => "greenIcon",    :display_icon_name => "fa fa-building-o"},
  {:active => 1, :name => 'Support Facilities',     :description => 'Support Facilities',         :class_name => 'SupportFacility',   :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-building"},
  {:active => 1, :name => 'Support Vehicles',       :description => 'Support Vehicles',           :class_name => 'SupportVehicle',    :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-car"},

  {:active => 1, :name => 'Maintenance Equipment',    :description => 'Maintenance Equipment',      :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-wrench"},
  {:active => 1, :name => 'Facilities Equipment',     :description => 'Facilities Equipment',       :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-lightbulb-o"},
  {:active => 1, :name => 'IT Equipment',             :description => 'IT Equipment',               :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-laptop"},
  {:active => 1, :name => 'Office Equipment',         :description => 'Office Equipment',           :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-inbox"},
  {:active => 1, :name => 'Communications Equipment', :description => 'Communications Equipment',   :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-phone"},
  {:active => 1, :name => 'Signals/Signs',            :description => 'Signals and Signs',          :class_name => 'Equipment',         :map_icon_name => "blueIcon",     :display_icon_name => "fa fa-h-square"}
]

asset_subtypes = [
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Std 40 FT', :image => 'bus_std_40_ft.png', :description => 'Bus Std 40 FT'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Std 35 FT', :image => 'bus_std_35_ft.png', :description => 'Bus Std 35 FT'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus 30 FT',     :image => 'bus_std_30_ft.png', :description => 'Bus 30 FT'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus < 30 FT',   :image => 'bus_std_lt_30_ft.jpg', :description => 'Bus < 30 FT'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus School',   :image => 'bus_school.jpg',     :description => 'Bus School'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Articulated', :image => 'bus_articulated.jpg',             :description => 'Bus Articulated'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Commuter/Suburban', :image => 'bus_commuter.png',       :description => 'Bus Commuter/Suburban'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Intercity', :image => 'bus_intercity.jpg',               :description => 'Bus Intercity'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Trolley Std', :image => 'trolley_std.jpg',             :description => 'Bus Trolley Std'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Trolley Articulated',:image => 'trolley_articulated.png',      :description => 'Bus Trolley Articulated'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Double Deck', :image => 'bus_double_deck.jpg',             :description => 'Bus Double Deck'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Bus Dual Mode',                  :image => 'bus_dual_mode.png',                :description => 'Bus Dual Mode'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Van',                            :image => 'van.jpg',                        :description => 'Van'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Sedan/Station Wagon',            :image => 'sedan.jpg',         :description => 'Sedan/Station Wagon'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Revenue Vehicles', :name => 'Ferry Boat',                     :image => 'ferry.jpg',                  :description => 'Ferry Boat'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Bus Shelter',           :image => 'bus_shelter.png', :description => 'Bus Shelter'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Bus Station',           :image => 'bus_station.png', :description => 'Bus Station'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Ferry Dock',            :image => 'ferry_dock.png', :description => 'Ferry Dock'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Intermodal Terminal',   :image => 'intermodal_terminal.png', :description => 'Intermodal Terminal'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Park and Ride Lot',     :image => 'park_and_ride_lot.png', :description => 'Park and Ride Lot'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Parking Garage',        :image => 'parking_garage.png', :description => 'Parking Garage'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Stations/Stops/Terminals', :name => 'Parking Lot',           :image => 'parking_lot.png', :description => 'Parking Lot'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Administration Building',         :image => 'administration_building.png', :description => 'Administration Building'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Bus Maintenance Facility',        :image => 'bus_maintenance_facility.png', :description => 'Bus Maintenance Facility'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Bus Parking Facility',            :image => 'bus_parking_facility.png', :description => 'Bus Parking Facility'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Bus Turnaround Facility',         :image => 'bus_turnaround_facility.png', :description => 'Bus Turnaround Facility'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Storage Yard',                    :image => 'storage_yard.png', :description => 'Storage Yard'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Facilities', :name => 'Other Support Facility',          :image => 'storage_yard.png', :description => 'Other Support Facility'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Van',                            :image => 'van.jpg',                        :description => 'Van'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Tow Truck',                      :image => 'tow_truck.jpg',                  :description => 'Tow Truck'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Sedan/Station Wagon',            :image => 'sedan.jpg',                      :description => 'Sedan/Station Wagon'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Pickup Truck',                   :image => 'pickup_truck.png',               :description => 'Pickup/Utility Truck'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Sports Utility Vehicle',         :image => 'pickup_truck.png',               :description => 'Sports Utility Vehicle'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Support Vehicles',  :name => 'Other Support Vehicle',          :image => 'pickup_truck.png',               :description => 'Other Support Vehicle'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Maintenance Equipment',  :name => 'Bus Maintenance Equipment',      :image => 'pickup_truck.png',     :description => 'Bus Maintenance Equipment'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Maintenance Equipment',  :name => 'Other Maintenance Equipment',:image => 'pickup_truck.png',     :description => 'Other Maintenance Equipment'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Facilities Equipment',  :name => 'Mechanical Equipment',      :image => 'pickup_truck.png',     :description => 'Mechanical Equipment'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Facilities Equipment',  :name => 'Electrical Equipment',      :image => 'pickup_truck.png',     :description => 'Electrical Equipment'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Facilities Equipment',  :name => 'Structural Equipment',      :image => 'pickup_truck.png',     :description => 'Structural Equipment'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Facilities Equipment',  :name => 'Other Facilities Equipment',:image => 'pickup_truck.png',     :description => 'Other Facilities Equipment'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'IT Equipment',  :name => 'Hardware',         :image => 'pickup_truck.png',     :description => 'Hardware'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'IT Equipment',  :name => 'Software',         :image => 'pickup_truck.png',     :description => 'Hardware'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'IT Equipment',  :name => 'Networks',         :image => 'pickup_truck.png',     :description => 'Hardware'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'IT Equipment',  :name => 'Storage',          :image => 'pickup_truck.png',     :description => 'Storage'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'IT Equipment',  :name => 'Other IT Equipment',    :image => 'pickup_truck.png',     :description => 'Hardware'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Office Equipment',  :name => 'Furniture',         :image => 'pickup_truck.png',     :description => 'Office Furniture'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Office Equipment',  :name => 'Supplies',          :image => 'pickup_truck.png',     :description => 'Office Supplies'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Office Equipment',  :name => 'Other Office Equipment',    :image => 'pickup_truck.png',     :description => 'Other Office Equipment'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Communications Equipment',  :name => 'Vehicle Location Systems',   :image => 'pickup_truck.png',     :description => 'Vehicle Location Systems'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Communications Equipment',  :name => 'Radios',                     :image => 'pickup_truck.png',     :description => 'Radios'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Communications Equipment',  :name => 'Surveillance & Security',    :image => 'pickup_truck.png',     :description => 'Surveillance & Security'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Communications Equipment',  :name => 'Fare Collection Systems',    :image => 'pickup_truck.png',     :description => 'Fare Collection Systems'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Communications Equipment',  :name => 'Other Communications Equipment',    :image => 'pickup_truck.png',     :description => 'Other Communication Equipment'},

  {:active => 1, :belongs_to => 'asset_type',  :type => 'Signals/Signs',  :name => 'Route Signage',    :image => 'pickup_truck.png',     :description => 'Route Signage'},
  {:active => 1, :belongs_to => 'asset_type',  :type => 'Signals/Signs',  :name => 'Other Signage Equipment',    :image => 'pickup_truck.png',     :description => 'Other Signage Equipment'}

]
fuel_types = [
  {:active => 1, :name => 'Unknown',                        :code => 'XX', :description => 'No Fuel type specified.'},
  {:active => 1, :name => 'Biodiesel',                      :code => 'BD', :description => 'Biodiesel.'},
  {:active => 1, :name => 'Bunker Fuel',                    :code => 'BF', :description => 'Bunker Fuel.'},
  {:active => 1, :name => 'Compressed Natural Gas',         :code => 'CN', :description => 'Compressed Natutral Gas.'},
  {:active => 1, :name => 'Diesel Fuel',                    :code => 'DF', :description => 'Diesel Fuel.'},
  {:active => 1, :name => 'Dual Fuel',                      :code => 'DU', :description => 'Dual Fuel.'},
  {:active => 1, :name => 'Electric Battery',               :code => 'EB', :description => 'Electric Battery.'},
  {:active => 1, :name => 'Electric Propulsion',            :code => 'EP', :description => 'Electric Propulsion.'},
  {:active => 1, :name => 'Ethanol',                        :code => 'ET', :description => 'Ethanol.'},
  {:active => 1, :name => 'Gasoline',                       :code => 'GA', :description => 'Gasoline.'},
  {:active => 1, :name => 'Hybrid Diesel',                  :code => 'HD', :description => 'Hybrid Diesel.'},
  {:active => 1, :name => 'Hybrid Gasoline',                :code => 'HG', :description => 'Hybrid Gasoline.'},
  {:active => 1, :name => 'Hydrogen',                       :code => 'HY', :description => 'Hydrogen.'},
  {:active => 1, :name => 'Kerosene',                       :code => 'KE', :description => 'Kerosene.'},
  {:active => 1, :name => 'Liquefied Natural Gas',          :code => 'LN', :description => 'Liquefied Natural Gas.'},
  {:active => 1, :name => 'Liquefied Petroleum Gas',        :code => 'LP', :description => 'Liquefied Petroleum Gas.'},
  {:active => 1, :name => 'Methanol',                       :code => 'MT', :description => 'Methanol.'},
  {:active => 1, :name => 'Other',                          :code => 'OR', :description => 'Other.'}
]
vehicle_features = [
  {:active => 1, :name => 'AVL System',           :code => 'AS', :description => 'Automatic Vehicle Location System.'},
  {:active => 1, :name => 'Lift Equipped',        :code => 'LE', :description => 'Lift Equipped.'},
  {:active => 1, :name => 'Electronic Ramp',      :code => 'ER', :description => 'Electronic Ramp.'},
  {:active => 1, :name => 'Video Cameras',        :code => 'VC', :description => 'Video Cameras.'},
  {:active => 1, :name => 'Fare Box (Standard)',  :code => 'FBS', :description => 'Fare Box (Standard).'},
  {:active => 1, :name => 'Fare Box (Electronic)',:code => 'FBE', :description => 'Fare Box (Electronic).'},
  {:active => 1, :name => 'Radio Equipped',       :code => 'RE', :description => 'Radio Equipped.'},
  {:active => 1, :name => 'Bike Rack',            :code => 'BR', :description => 'Bike Rack.'},
  {:active => 1, :name => 'Scheduling Software',  :code => 'SS', :description => 'Scheduling Software.'},
  {:active => 1, :name => 'WIFI',                 :code => 'WI', :description => 'WIFI.'}
]
vehicle_usage_codes = [
  {:active => 1, :name => 'Unknown',          :code => 'X', :description => 'No vehicle usage specified.'},
  {:active => 1, :name => 'Revenue Vehicle',  :code => 'R', :description => 'Revenue Vehicle.'},
  {:active => 1, :name => 'Support Vehicle',  :code => 'S', :description => 'Support Vehicle.'},
  {:active => 1, :name => 'Van Pool',         :code => 'V', :description => 'Van Pool.'},
  {:active => 1, :name => 'Paratransit',      :code => 'P', :description => 'Paratransit.'},
  {:active => 1, :name => 'Spare Inventory',  :code => 'I', :description => 'Spare Inventory.'}
]

vehicle_rebuild_types = [
  {:active => 1, :name => 'Mid-Life Powertrain',      :description => 'Mid-Life Powertrain'},
  {:active => 1, :name => 'Mid-Life Overhaul',        :description => 'Mid-Life Overhaul'},
  {:active => 1, :name => 'Life-Extending Overhaul',  :description => 'Life-Extending Overhaul'},
]

fta_mode_types = [
  # Rural Reporting Modes
  {:active => 1, :name => 'Unknown',                      :code => 'XX', :description => 'No FTA mode type specified.'},
  {:active => 1, :name => 'Bus',                          :code => 'MB', :description => 'Bus.'},
  {:active => 1, :name => 'Commuter Bus',                 :code => 'CB', :description => 'Commuter bus.'},
  {:active => 1, :name => 'Demand Response',              :code => 'DR', :description => 'Demand Response.'},
  {:active => 1, :name => 'Ferry Boat',                   :code => 'FB', :description => 'Ferryboat.'},
  {:active => 1, :name => 'Taxi',                         :code => 'TX', :description => 'Taxi.'},
  {:active => 1, :name => 'Vanpool',                      :code => 'VP', :description => 'Vanpool.'},
  {:active => 1, :name => 'Aerial Tramway',               :code => 'TR', :description => 'Aerial Tramway.'},
  {:active => 1, :name => 'Bus Rapid Transit',            :code => 'RB', :description => 'Bus rapid transit.'},
  {:active => 1, :name => 'Other',                        :code => 'OR', :description => 'Other.'}
  # Urban Reporting Modes
  #{:active => 1, :name => 'Jitney',                       :code => 'JT', :description => 'Jitney.'},
  #{:active => 1, :name => 'Publico',                      :code => 'PB', :description => 'Publico.'},
  #{:active => 1, :name => 'Trolley Bus',                  :code => 'TB', :description => 'Trolleybus.'},
  #{:active => 1, :name => 'Alaska Railroad',              :code => 'AR', :description => 'Alaska Railroad.'},
  #{:active => 1, :name => 'Monorail/Automated Guideway Transit',  :code => 'MG', :description => 'Monorail/Automated guideway transit.'},
  #{:active => 1, :name => 'Cable Car',                    :code => 'CC', :description => 'Cable car.'},
  #{:active => 1, :name => 'Commuter Rail',                :code => 'CR', :description => 'Commuter rail.'},
  #{:active => 1, :name => 'Heavy Rail',                   :code => 'HR', :description => 'Heavy rail.'},
  #{:active => 1, :name => 'Inclined Plane',               :code => 'IP', :description => 'Inclined plane.'},
  #{:active => 1, :name => 'Light Rail',                   :code => 'LR', :description => 'Light rail.'},
  #{:active => 1, :name => 'Street Car',                    :code => 'SR', :description => 'Streetcar.'},
  #{:active => 1, :name => 'Hybrid Rail',                  :code => 'HR', :description => 'Hybrid rail.'}
]
fta_bus_mode_types = [
  # Rural Reporting Modes
  {:active => 1, :name => 'Deviated Fixed Route', :code => 'DFR', :description => 'Deviated Fixed Route'},
  {:active => 1, :name => 'Fixed Route',          :code => 'FR', :description => 'Fixed route'},
  {:active => 1, :name => 'Both',                 :code => 'B', :description => 'Both deviated and fixed routes.'},
]
fta_service_types = [
  {:active => 1, :name => 'Unknown',                      :code => 'XX', :description => 'FTA Service type not specified.'},
  {:active => 1, :name => 'Directly Operated',            :code => 'DO', :description => 'Directly Operated.'},
  {:active => 1, :name => 'Purchased Transportation',     :code => 'PT', :description => 'Purchased Transportation.'}
]
fta_facility_types = [
  # Facility Types for Support Facilities
  {:active => 1, :name => 'Maintenance Facility (Service and Inspection)',     :description => 'Maintenance Facility (Service and Inspection).'},
  {:active => 1, :name => 'Heavy Maintenance and Overhaul (Backshop)',    :description => 'Heavy Maintenance and Overhaul (Backshop).'},
  {:active => 1, :name => 'General Purpose Maintenance Facility/Depot',       :description => 'General Purpose Maintenance Facility/Depot.'},
  {:active => 1, :name => 'Vehicle Washing Facility',     :description => 'Vehicle Washing Facility.'},
  {:active => 1, :name => 'Vehicle Blow-Down Facility',     :description => 'Vehicle Blow-Down Facility.'},
  {:active => 1, :name => 'Vehicle Fueling Facility',     :description => 'Vehicle Fueling Facility.'},
  {:active => 1, :name => 'Vehicle Testing Facility',     :description => 'Vehicle Testing Facility.'},
  {:active => 1, :name => 'Administrative Office/Sales Office',     :description => 'Administrative Office/Sales Office.'},
  {:active => 1, :name => 'Revenue Collection Facility',     :description => 'Revenue Collection Facility.'},
  {:active => 1, :name => 'Other Support Facility',     :description => 'Other Support Facility.'},
  # Facility Types for Transit Facilities
  {:active => 1, :name => 'Bus Transfer Station',     :description => 'Bus Transfer Station.'},
  {:active => 1, :name => 'Elevated Fixed Guideway Station',    :description => 'Elevated Fixed Guideway Station.'},
  {:active => 1, :name => 'At-Grade Fixed Guideway Station',       :description => 'At-Grade Fixed Guideway Station.'},
  {:active => 1, :name => 'Underground Fixed Guideway Station',     :description => 'Underground Fixed Guideway Station.'},
  {:active => 1, :name => 'Simple At-Grade Platform Station',     :description => 'Simple At-Grade Platform Station.'},
  {:active => 1, :name => 'Surface Parking Lot',     :description => 'Surface Parking Lot.'},
  {:active => 1, :name => 'Parking Structure',     :description => 'Parking Structure.'},
  {:active => 1, :name => 'Other Transit Facility',     :description => 'Other Transit Facility.'}
]

fta_agency_types = [
  {:active => 1, :name => 'Public Agency (Not DOT or Tribal)',      :description => 'Public Agency (Not DOT or Tribal).'},
  {:active => 1, :name => 'Public Agency (State DOT)',    :description => 'Public Agency (State DOT).'},
  {:active => 1, :name => 'Public Agency (Tribal)',       :description => 'Public Agency (Tribal).'},
  {:active => 1, :name => 'Private (Not for profit)',     :description => 'Private (Not for profit).'}
]
fta_service_area_types = [
  {:active => 1, :name => 'County/Independent city',          :description => 'County / Independent city.'},
  {:active => 1, :name => 'Multi-county/Independent city',    :description => 'Multi-county / Independent city.'},
  {:active => 1, :name => 'Multi-state',                      :description => 'Multi-state.'},
  {:active => 1, :name => 'Municipality',                     :description => 'Municipality.'},
  {:active => 1, :name => 'Reservation',                      :description => 'Reservation.'},
  {:active => 1, :name => 'Other',                            :description => 'Other.'}
]

fta_funding_types = [
  {:active => 1, :name => 'Unknown',                        :code => 'XX',    :description => 'FTA funding type not specified.'},
  {:active => 1, :name => 'Urbanized Area Formula Program', :code => 'UA',    :description => 'UA -Urbanized Area Formula Program.'},
  {:active => 1, :name => 'Other Federal funds',            :code => 'OF',    :description => 'OF-Other Federal funds.'},
  {:active => 1, :name => 'Non-Federal public funds',       :code => 'NFPA',  :description => 'NFPA-Non-Federal public funds.'},
  {:active => 1, :name => 'Non-Federal private funds',      :code => 'NFPE',  :description => 'NFPE-Non-Federal private funds.'}
]

fta_ownership_types = [
  # Rural Reporting Ownership Types
  {:active => 1, :name => 'Unknown',                                      :code => 'XX',    :description => 'FTA ownership type not specified.'},
  {:active => 1, :name => 'Owned by Service Provider',                    :code => 'OSP',  :description => 'Owned by Service Provider.'},
  {:active => 1, :name => 'Owned by Public Agency for Service Provider',  :code => 'OPA',  :description => 'Owned by Public Agency for Service Provider.'},
  {:active => 1, :name => 'Leased by Service Provider',                   :code => 'LSP',  :description => 'Leased by Service Provider.'},
  {:active => 1, :name => 'Leased by Public Agency for Service Provider', :code => 'LPA',  :description => 'Leased by Public Agency for Service Provider.'},
  {:active => 1, :name => 'Other',                                        :code => 'OR',  :description => 'Other.'}
]

fta_vehicle_types = [
  # Rural Reporting Types
  {:active => 1, :name => 'Automobile',             :code => 'AO',  :description => 'Automobile.'},
  {:active => 1, :name => 'Bus',                    :code => 'BU',  :description => 'Bus.'},
  {:active => 1, :name => 'Cutaway',                :code => 'CU',  :description => 'Cutaway.'},
  {:active => 1, :name => 'Ferry Boat',             :code => 'FB',  :description => 'Ferryboat.'},
  {:active => 1, :name => 'Mini Van',               :code => 'MV',  :description => 'Minivan.'},
  {:active => 1, :name => 'Over-The-Road Bus',      :code => 'BR',  :description => 'Over-The-Road Bus.'},
  {:active => 1, :name => 'School Bus',             :code => 'SB',  :description => 'School Bus.'},
  {:active => 1, :name => 'Sports Utility Vehicle', :code => 'SV',  :description => 'Sports Utility Vehicle.'},
  {:active => 1, :name => 'Van',                    :code => 'VN',  :description => 'Van.'},
  {:active => 1, :name => 'Articulated Bus',        :code => 'AB',  :description => 'Articulated Bus.'},
  {:active => 1, :name => 'Double Decker Bus',      :code => 'DB',  :description => 'Double Decker Bus.'},
  {:active => 1, :name => 'Aerial Tramway',         :code => 'TR',  :description => 'Aerial Tramway.'},
  {:active => 1, :name => 'Other',                  :code => 'OR',  :description => 'Other.'},

  {:active => 1, :name => 'Unknown',                :code => 'XX', :description => 'Vehicle type not specified.'},

  # Urban Reporting Types
  {:active => 1, :name => 'Automated Guideway Vehicle',        :code => 'AG',  :description => 'Automated Guideway Vehicle.'},
  {:active => 1, :name => 'Cable Car',              :code => 'CC',  :description => 'Cable Car.'},
  {:active => 1, :name => 'Heavy Rail Passenger Car',  :code => 'HR',  :description => 'Heavy Rail Passenger Car.'},
  {:active => 1, :name => 'Inclined Plane Vehicle', :code => 'IP',  :description => 'Inclined Plane Vehicle.'},
  {:active => 1, :name => 'Light Rail Vehicle', :code => 'LR',  :description => 'Light Rail Vehicle.'},
  {:active => 1, :name => 'Monorail/Automated Guideway', :code => 'MO',  :description => 'Monorail/Automated Guideway.'},
  {:active => 1, :name => 'Commuter Rail Locomotive',                   :code => 'RL',  :description => 'Commuter Rail Locomotive.'},
  {:active => 1, :name => 'Commuter Rail Passenger Coach',              :code => 'RP',  :description => 'Commuter Rail Passenger Coach.'},
  {:active => 1, :name => 'Commuter Rail Self-Propelled Passenger Car', :code => 'RS',  :description => 'Commuter Rail Self-Propelled Passenger Car.'},
  {:active => 1, :name => 'Trolley Bus',            :code => 'TB',  :description => 'Trolley Bus.'},
  {:active => 1, :name => 'Taxicab Sedan',          :code => 'TS',  :description => 'Taxicab Sedan.'},
  {:active => 1, :name => 'Taxicab Van',            :code => 'TV',  :description => 'Taxicab Van.'},
  {:active => 1, :name => 'Taxicab Station Wagon',  :code => 'TW',  :description => 'Taxicab Station Wagon.'},
  {:active => 1, :name => 'Vintage Trolley/Streetcar',:code => 'VT',  :description => 'Vintage Trolley/Streetcar.'}
]

facility_capacity_types = [
  {:active => 1, :name => 'N/A',                             :description => 'Not applicable.'},
  {:active => 1, :name => 'Less than 200 vehicles',          :description => 'Less than 200 vehicles.'},
  {:active => 1, :name => 'Between 200 and 300 vehicles',    :description => 'Between 200 and 300 vehicles.'},
  {:active => 1, :name => 'Over 300 vehicles',               :description => 'Over 300 vehicles.'}
]
facility_features = [
  {:active => 1, :name => 'Moving walkways',    :code => 'MW', :description => 'Moving walkways.'},
  {:active => 1, :name => 'Ticketing',          :code => 'TK', :description => 'Ticketing.'},
  {:active => 1, :name => 'Information kiosks', :code => 'IK', :description => 'Information kiosks.'},
  {:active => 1, :name => 'Restrooms',          :code => 'RR', :description => 'Restrooms.'},
  {:active => 1, :name => 'Concessions',        :code => 'CS', :description => 'Concessions.'},
  {:active => 1, :name => 'Telephones',         :code => 'TP', :description => 'Telephones.'},
  {:active => 1, :name => 'ATM',                :code => 'AT', :description => 'ATM.'},
  {:active => 1, :name => 'WIFI',               :code => 'WI', :description => 'WIFI.'}
]

leed_certification_types = [
  {:active => 1, :name => 'Not Certified',  :description => 'Not Certified'},
  {:active => 1, :name => 'Certified',  :description => 'Certified'},
  {:active => 1, :name => 'Silver',  :description => 'Silver'},
  {:active => 1, :name => 'Gold',  :description => 'Gold'},
  {:active => 1, :name => 'Platinum',  :description => 'Platinum'},
]

district_types = [
  {:active => 1, :name => 'State',        :description => 'State.'},
  {:active => 1, :name => 'District',     :description => 'Engineering District.'},
  {:active => 1, :name => 'MSA',          :description => 'Metropolitan Statistical Area.'},
  {:active => 1, :name => 'County',       :description => 'County.'},
  {:active => 1, :name => 'City',         :description => 'City.'},
  {:active => 1, :name => 'Borough',      :description => 'Borough.'},
  {:active => 1, :name => 'MPO/RPO',      :description => 'MPO or RPO planning area.'},
  {:active => 1, :name => 'Postal Code',  :description => 'ZIP Code or Postal Area.'}
]

file_content_types = [
  {:active => 1, :name => 'Status Updates',     :class_name => 'StatusUpdatesFileHandler',    :builder_name => "StatusUpdatesTemplateBuilder",  :description => 'Worksheet records condition, usage, and operational updates for exisiting inventory.'},
  {:active => 1, :name => 'Disposition Updates',  :class_name => 'DispositionUpdatesFileHandler', :builder_name => "DispositionUpdatesTemplateBuilder", :description => 'Worksheet contains final disposition updates for existing inventory.'}
]

service_provider_types = [
  {:active => 1, :name => 'Urban',            :code => 'URB',   :description => 'Operates in an urban area.'},
  {:active => 1, :name => 'Rural',            :code => 'RUR',   :description => 'Operates in a rural area.'},
  {:active => 1, :name => 'Shared Ride',      :code => 'SHR',   :description => 'Provides shared ride services.'},
  {:active => 1, :name => 'Intercity Bus',    :code => 'ICB',   :description => 'Provides intercity bus services.'},
  {:active => 1, :name => 'Intercity Rail',   :code => 'ICR',   :description => 'Provides intercity rail services.'}
]

vehicle_storage_method_types = [
  {:active => 1,  :name => 'Unknown',:code => 'X', :description => 'Vehicle storage method not supplied.'},
  {:active => 1,  :name => 'Indoors', :code => 'I', :description => 'Vehicle is always stored indoors.'},
  {:active => 1,  :name => 'Outdoors', :code => 'O', :description => 'Vehicle is always stored outdoors.'},
  {:active => 1,  :name => 'Indoor/Outdoor', :code => 'B', :description => 'Vehicle is stored both indoors and outdoors.'}
]

maintenance_provider_types = [
  {:active => 1,  :name => 'Unknown',         :code => 'XX', :description => 'Maintenance provider not supplied.'},
  {:active => 1,  :name => 'Self Maintained', :code => 'SM', :description => 'Self Maintained.'},
  {:active => 1,  :name => 'County',          :code => 'CO', :description => 'County.'},
  {:active => 1,  :name => 'Public Agency',   :code => 'PA', :description => 'Public Agency.'},
  {:active => 1,  :name => 'Private Entity',  :code => 'PE', :description => 'Private Entity.'}
]

funding_source_types = [
  {:active => 1, :name => 'Federal',  :description => 'Federal Funding Source'},
  {:active => 1, :name => 'State',    :description => 'State Funding Source'},
  {:active => 1, :name => 'Other',    :description => 'Other Funding Source'}
]

organization_types = [
  {:active => 1,  :name => 'Grantor',           :class_name => "Grantor",               :display_icon_name => "fa fa-usd",    :map_icon_name => "redIcon",    :description => 'Organizations who manage funding grants.'},
  {:active => 1,  :name => 'TransitOperator',   :class_name => "TransitOperator",       :display_icon_name => "fa fa-bus",    :map_icon_name => "greenIcon",  :description => 'Transit Operator.'},
  {:active => 1,  :name => 'Planning Partner',  :class_name => "PlanningOrganization",  :display_icon_name => "fa fa-group",  :map_icon_name => "purpleIcon", :description => 'Organizations who need visibility into grantee assets for planning purposes.'}
]

governing_body_types = [
  {:active => 1, :name => 'Corporate Board of Directors',   :description => 'Corporate Board of Directors'},
  {:active => 1, :name => 'Authority Board',   :description => 'Board of Directors'},
  {:active => 1, :name => 'County',   :description => 'County'},
  {:active => 1, :name => 'City',   :description => 'City'},
  {:active => 1, :name => 'Other',                :description => 'Other Governing Body'}
]

replace_tables = %w{ asset_types fuel_types vehicle_features vehicle_usage_codes vehicle_rebuild_types fta_mode_types fta_bus_mode_types fta_agency_types fta_service_area_types
  fta_service_types fta_funding_types fta_ownership_types fta_vehicle_types facility_capacity_types
  facility_features leed_certification_types district_types maintenance_provider_types funding_source_types
  file_content_types service_provider_types organization_types
  vehicle_storage_method_types fta_facility_types governing_body_types
  }

replace_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end

table_name = 'asset_subtypes'
puts "  Loading #{table_name}"
if is_mysql
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
elsif is_sqlite
  ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
else
  ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
end
data = eval(table_name)
data.each do |row|
  x = AssetSubtype.new(row.except(:belongs_to, :type))
  x.asset_type = AssetType.where(:name => row[:type]).first
  x.save!
end

require_relative File.join("seeds", 'team_ali_code_seeds') # TEAM ALI Codes are seeded from a separate file
require_relative File.join("seeds", 'rail.seeds') # TEAM ALI Codes are seeded from a separate file

# These tables are merged with core tables

roles = [
  {:name => 'director_transit_operations'},
  {:name => 'ntd_contact'}
]

asset_event_types = [
  {:active => 1, :name => 'Update the mileage',       :display_icon_name => "fa fa-road",       :description => 'Mileage Update',       :class_name => 'MileageUpdateEvent',      :job_name => 'AssetMileageUpdateJob'},
  {:active => 1, :name => 'Update the operations metrics',      :display_icon_name => "fa fa-calculator",        :description => 'Operations Update',:class_name => 'OperationsUpdateEvent',     :job_name => 'AssetOperationsUpdateJob'},
  {:active => 1, :name => 'Update the facility operations metrics',      :display_icon_name => "fa fa-calculator",        :description => 'Facility Operations Update',:class_name => 'FacilityOperationsUpdateEvent',     :job_name => 'AssetFacilityOperationsUpdateJob'},
  {:active => 1, :name => 'Update the vehicle use metrics',           :display_icon_name => "fa fa-line-chart",      :description => 'Vehicle Usage Update',     :class_name => 'VehicleUsageUpdateEvent',          :job_name => 'AssetVehicleUsageUpdateJob'},
  {:active => 1, :name => 'Update the storage method',       :display_icon_name => "fa fa-star-half-o",       :description => 'Storage Method',       :class_name => 'StorageMethodUpdateEvent',      :job_name => 'AssetStorageMethodUpdateJob'},
  {:active => 1, :name => 'Update the usage codes',       :display_icon_name => "fa fa-star-half-o",       :description => 'Usage Codes',       :class_name => 'UsageCodesUpdateEvent',      :job_name => 'AssetUsageCodesUpdateJob'}
]


condition_estimation_types = [
  {:active => 1, :name => 'TERM',           :class_name => 'TermEstimationCalculator',          :description => 'Asset condition is estimated using FTA TERM approximations.'}
]

report_types = [
  {:active => 1, :name => 'Planning Report',     :display_icon_name => "fa fa-line-chart",  :description => 'Planning Report.'},
]

service_life_calculation_types = [
  {:active => 1, :name => 'Age and Mileage',                :class_name => 'ServiceLifeAgeAndMileage',   :description => 'Calculate the replacement year based on the age of the asset or mileage whichever minimizes asset life.'},
  {:active => 1, :name => 'Age and Mileage and Condition',  :class_name => 'ServiceLifeAgeAndMileageAndCondition',   :description => 'Calculate the replacement year based on the age of the asset or condition or mileage whichever minimizes asset life.'},
  {:active => 1, :name => 'Condition and Mileage',          :class_name => 'ServiceLifeConditionAndMileage',   :description => 'Calculate the replacement year based on the condition of the asset or mileage whichever minimizes asset life.'}
]

merge_tables = %w{ roles asset_event_types condition_estimation_types service_life_calculation_types }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end



puts "======= Processing TransAM Transit Reports  ======="

reports = [
  {:active => 1, :belongs_to => 'report_type', :type => "Inventory Report",
    :name => 'Useful Life Consumed Report',
    :class_name => "ServiceLifeConsumedReport",
    :view_name => "generic_chart",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Displays a summary of the amount of useful life that has been consumed as a percentage of all assets.',
    :chart_type => 'column',
    :chart_options => "{is3D : true, isStacked: true, fontSize: 10, hAxis: {title: 'Percent of expected useful life consumed'}, vAxis: {title: 'Share of all assets'}}"},
  {:active => 1, :belongs_to => 'report_type', :type => "Inventory Report",
    :name => 'Asset Condition Report',
    :class_name => "AssetConditionReport",
    :view_name => "generic_chart",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Displays asset counts by condition.',
    :chart_type => 'pie',
    :chart_options => '{is3D : true}'},
  {:active => 1, :belongs_to => 'report_type', :type => "Inventory Report",
    :name => 'Asset Subtype Report',
    :class_name => "AssetSubtypeReport",
    :view_name => "generic_chart",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Displays asset counts by subtypes.',
    :chart_type => 'pie',
    :chart_options => '{is3D : true}'},
  {:active => 1, :belongs_to => 'report_type', :type => "Inventory Report",
    :name => 'Asset Age Report',
    :class_name => "AssetAgeReport",
    :view_name => "generic_chart",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Displays asset counts by age.',
    :chart_type => 'column',
    :chart_options => "{is3D : true, isStacked : true, hAxis: {title: 'Age (years)'}, vAxis: {title: 'Count'}}"},
  {:active => 1, :belongs_to => 'report_type', :type => "Capital Needs Report",
    :name => 'Backlog Report',
    :class_name => "BacklogReport",
    :view_name => "generic_report",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Determines backlog needs.'},
  {:active => 1, :belongs_to => 'report_type', :type => "Inventory Report",
    :name => 'Asset Type by Org Report',
    :class_name => "CustomSqlReport",
    :view_name => "generic_report_table",
    :show_in_nav => 0,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Displays a sumamry of asset types by agency.',
    :custom_sql => "SELECT c.short_name AS 'Org', b.name AS 'Type', COUNT(*) AS 'Count' FROM assets a LEFT JOIN asset_subtypes b ON a.asset_subtype_id = b.id LEFT JOIN organizations c ON a.organization_id = c.id GROUP BY a.organization_id, a.asset_subtype_id ORDER BY c.short_name, b.name"},
  {:active => 1, :belongs_to => 'report_type', :type => "Planning Report",
    :name => 'Vehicle Replacement Report',
    :class_name => "VehicleReplacementReport",
    :view_name => "vehicle_replacement_report",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Reports the list of vehicles scheduled to be replaced.'},
    {:active => 1, :belongs_to => 'report_type', :type => "Planning Report",
    :name => 'State of Good Repair Report',
    :class_name => "StateOfGoodRepairReport",
    :view_name => "state_of_good_repair_report",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Reports an agency\'s current State of Good Repair.'},
    {:active => 1, :belongs_to => 'report_type', :type => "Planning Report",
    :name => 'Disposition Report',
    :class_name => "AssetDispositionReport",
    :view_name => "asset_disposition_report",
    :show_in_nav => 1,
    :show_in_dashboard => 0,
    :roles => 'user,manager',
    :description => 'Reports Vehicles which have been disposed.'}
]

table_name = 'reports'
puts "  Merging #{table_name}"
data = eval(table_name)
data.each do |row|
  puts "Creating Report #{row[:name]}"
  x = Report.new(row.except(:belongs_to, :type))
  x.report_type = ReportType.find_by(:name => row[:type])
  x.save!
end
