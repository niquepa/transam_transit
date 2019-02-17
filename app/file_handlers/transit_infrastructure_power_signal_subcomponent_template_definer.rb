class TransitInfrastructurePowerSignalSubcomponentTemplateDefiner
  require 'rubyXL'

  SHEET_NAME = InventoryUpdatesFileHandler::SHEET_NAME


  def green_label_cells
    green_label_cells = [
      @agency_column_number,
      @vin_column_number,
      @asset_id_column_number,
      @class_column_number,
      @type_column_number,
      @subtype_column_number,
      @estimated_service_life_category_column_number,
      @manufacturer_column_number,
      @model_column_number,
      @chassis_column_number,
      @year_of_manufacture_column_number,
      @fuel_type_column_number,
      @length_column_number,
      @length_units_column_number,
      @seating_capacity_column_number,
      @standing_capacity_column_number,
      @ada_accessible_column_number,
      @wheelchair_capacity_column_number,
      @cost_purchase_column_number,
      @funding_type_column_number,
      @direct_capital_responsibility_column_number,
      @percent_capital_responsibility_column_number,
      @ownership_type_column_number,
      @purchased_new_column_number,
      @in_service_date_column_number,
      @priamry_mode_column_number,
      @service_type_primary_mode_column_number,
      @dedicated_asset_column_number,
      @service_status_column_number,
      @date_of_last_service_status_column_number
    ]
  end

  def white_label_cells
    white_label_cells = [
      @external_id_column_number,
      @gross_vehicle_weight_column_number,
      @lift_ramp_manufacturer_column_number,
      @program_1_column_number,
      @percent_1_column_number,
      @program_2_column_number,
      @percent_2_column_number,
      @program_3_column_number,
      @percent_3_column_number,
      @program_4_column_number,
      @percent_4_column_number,
      @purchase_date_column_number,
      @contract_purchase_order_column_number,
      @contract_po_type_column_number,
      @vendor_column_number,
      @warranty_column_number,
      @warranty_expiration_date_column_number,
      @operator_column_number,
      @features_column_number,
      @supports_another_mode_column_number,
      @service_type_supports_another_mode_column_number,
      @plate_number_column_number,
      @title_number_column_number,
      @title_owner_column_number,
      @lienholder_column_number,
      @odometer_reading_column_number,
      @date_last_odometer_reading_column_number,
      @condition_column_number,
      @date_last_condition_reading_column_number,
      @rebuild_rehabilitation_total_cost_column_number,
      @rebuild_rehabilitation_extend_useful_life_months_column_number,
      @rebuild_rehabilitation_extend_useful_life_miles_column_number,
      @date_of_rebuild_rehabilitation_column_number,
    ]
  end

  def grey_label_cells
    grey_label_cells = [
        @manufacturer_other_column_number,
        @model_other_column_number,
        @chasis_other_column_number,
        @fuel_type_other_column_number,
        @dual_fuel_type_other_column_number,
        @lift_ramp_manufacturer_other_column_number,
        @ownership_type_other_column_number,
        @vendor_other_column_number,
        @operator_other_column_number,
        @title_owner_other_column_number,
        @lienholder_other_column_number,
    ]
  end

  def setup_instructions()
    instructions = [
        '• Components & Sub-Componentstab contains a table where users should enter asset data. Users should enter 1 component / sub-component asset selection per row and 1 attribute per column',
        '• For Characteristics: There are three unique Component / Sub-Component Types in the Characteristics section - Fixed Signals-Signals, Fixed Signals-Mounting, and Signal House. Only data for a single component / sub-component should be entered per row. i.e. if you wish to enter data for Fixed Signals-Signals and Fixed Signals-Mounting, this requires two separate rows of data entry. In addition, if you wish to enter three types of Signal House records, this requires three separate rows of data entry.',
        '• For Characteristics: Not all components and sub-components are applicable to all forms of Power & Signal segments. i.e. some lines may not included signal houses.',
        '• Green Cells are required in the system',
        '• White Cells are recommended but not required',
        '• Grey Cells are only applicable if the user selects Other or under other unique circumstances (some may be required if "Other" is selected)',
        '• Asset / Segment IDs and Row Names are frozen to assist in scrolling through the table',
        '• For Vendor: Initially, all clients have only an Other option available.  When selecting Other, add a value in the corresponding Other field. Over time the available options will be updated.',
        "• For Program/Pcnt: The system's front-end is configured to add as many combination values as needed. We have provided you with four values for each.",
        '• Contract/Purchase Order (PO) # and Contract / PO Type can additionally be customized to have multiple values. This field is meant to contain different types of Contract/PO types. If applicable, select the value that applies best.',
        '• The List of Fields tab displays a table of all the attributes sorted by color (required status)'
    ]
  end

  def setup_lookup_sheet(wrkb, lookups)
    @lookups = lookups
  end

  def add_columns(sheet, template, org, fta_asset_class, earliest_date)

    dark_green_fill = '6BB14A'
    light_green_fill = '6BB14A'
    grey_fill = 'DBDBDB'
    white_fill = '000000'

    # TODO I almost want to make a class that is just all of these column definitions. Then the builder classes are just a list of calls to make up what is needed
    template.add_column(sheet, 'Agency', 'Identification & Classification', {name: 'required_string'}, {
            :type => :list,
            :formula1 => "lists!#{template.get_lookup_cells('organizations')}",
            :showErrorMessage => true,
            :errorTitle => 'Wrong input',
            :error => 'Select a value from the list',
            :errorStyle => :stop,
            :showInputMessage => true,
            :promptTitle => 'Organization',
            :prompt => 'Only values in the list are allowed'})


    template.add_column(sheet, 'Asset / Segment ID', 'Identification & Classification', {name: 'required_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('power_signals_for_subcomponents')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Asset / Segment ID',
        :prompt => 'Only values in the list are allowed'})


    template.add_column(sheet, 'Component Id', 'Characteristics', {name: 'required_string'})

    template.add_column(sheet, 'Component / Sub-Component', 'Characteristics', {name: 'required_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('subcomponents_for_powersignal')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Component / Sub-Component',
        :prompt => 'Only values in the list are allowed'})

    template.add_column(sheet, 'Description', 'Characteristics - Fixed Signals (Signals)', {name: 'recommended_string'})

    template.add_column(sheet, 'Year of Construction', 'Characteristics - Fixed Signals (Signals)', {name: 'recommended_year'}, {
        :type => :whole,
        :operator => :between,
        :formula1 => earliest_date.strftime("%Y"),
        :formula2 => Date.today.strftime("%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Year must be after #{earliest_date.year}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Year of Construction',
        :prompt => "Only values greater than #{earliest_date.year}"}, 'default_values', [Date.today.year.to_s])

    template.add_column(sheet, 'Manufacturer', 'Characteristics - Fixed Signals (Signals)', {name: 'recommended_string'})
    template.add_column(sheet, 'Model', 'Characteristics - Fixed Signals (Signals)', {name: 'recommended_string'})

    template.add_column(sheet, 'Signal Type', 'Characteristics - Fixed Signals (Signals)', {name: 'recommended_year'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('fixed_signal_signal_types')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Signal Type',
        :prompt => 'Only values in the list are allowed'})

    template.add_column(sheet, 'Description', 'Characteristics - Fixed Signals (Mounting)', {name: 'recommended_string'})

    template.add_column(sheet, 'Year of Construction', 'Characteristics - Fixed Signals (Mounting)', {name: 'recommended_year'}, {
        :type => :whole,
        :operator => :between,
        :formula1 => earliest_date.strftime("%Y"),
        :formula2 => Date.today.strftime("%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Year must be after #{earliest_date.year}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Year of Construction',
        :prompt => "Only values greater than #{earliest_date.year}"}, 'default_values', [Date.today.year.to_s])

    template.add_column(sheet, 'Manufacturer', 'Characteristics - Fixed Signals (Mounting)', {name: 'recommended_string'})
    template.add_column(sheet, 'Model', 'Characteristics - Fixed Signals (Mounting)', {name: 'recommended_string'})

    template.add_column(sheet, 'Mounting Type', 'Characteristics - Fixed Signals (Mounting)', {name: 'recommended_year'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('fixed_signal_mounting_types')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Mounting Type',
        :prompt => 'Only values in the list are allowed'})

    template.add_column(sheet, 'Description', 'Characteristics - Signal House', {name: 'recommended_string'})

    template.add_column(sheet, 'Year of Construction', 'Characteristics - Signal House', {name: 'recommended_year'}, {
        :type => :whole,
        :operator => :between,
        :formula1 => earliest_date.strftime("%Y"),
        :formula2 => Date.today.strftime("%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Year must be after #{earliest_date.year}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Year of Construction',
        :prompt => "Only values greater than #{earliest_date.year}"}, 'default_values', [Date.today.year.to_s])

    template.add_column(sheet, 'Program #1', 'Funding', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('programs')}",
        # :formula1 => "lists!#{get_lookup_cells('organizations')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Program #1',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Pcnt #1', 'Funding', {name: 'recommended_pcnt'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => '0',
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Must be integer >= 0',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Pcnt #1',
        :prompt => 'Only integers greater than or equal to 0'})

    template.add_column(sheet, 'Program #2', 'Funding', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('programs')}",
        # :formula1 => "lists!#{get_lookup_cells('organizations')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Program #2',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Pcnt #2', 'Funding', {name: 'recommended_pcnt'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => '0',
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Must be integer >= 0',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Pcnt #2',
        :prompt => 'Only integers greater than or equal to 0'})

    template.add_column(sheet, 'Program #3', 'Funding', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('programs')}",
        # :formula1 => "lists!#{get_lookup_cells('organizations')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Program #3',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Pcnt #3', 'Funding', {name: 'recommended_pcnt'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => '0',
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Must be integer >= 0',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Pcnt #3',
        :prompt => 'Only integers greater than or equal to 0'})

    template.add_column(sheet, 'Program #4', 'Funding', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('programs')}",
        # :formula1 => "lists!#{get_lookup_cells('organizations')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Program #4',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Pcnt #4', 'Funding', {name: 'recommended_pcnt'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => '0',
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Must be integer >= 0',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Pcnt #4',
        :prompt => 'Only integers greater than or equal to 0'})

    template.add_column(sheet, 'Cost (Purchase)', 'Funding', {name: 'required_currency'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => '0',
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Must be integer >= 0',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Purchase Cost',
        :prompt => 'Only integers greater than or equal to 0'})

    template.add_column(sheet, 'Purchased New', 'Procurement & Purchase', {name: 'required_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('booleans')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Purchased New',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['YES'])

    template.add_column(sheet, 'Purchase Date', 'Procurement & Purchase', {name: 'required_date'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => earliest_date.strftime("%-m/%d/%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Purchase Date',
        :prompt => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}"}, 'default_values', [Date.today.strftime('%m/%d/%Y')])

    template.add_column(sheet, 'Contract/Purchase Order (PO) #', 'Procurement & Purchase', {name: 'recommended_string'})

    template.add_column(sheet, 'Contract/PO Type', 'Procurement & Purchase', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('purchase_order_types')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Contract/PO Type',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Vendor', 'Procurement & Purchase', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('vendors')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Vendor',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['NO'])

    template.add_column(sheet, 'Vendor (Other)', 'Procurement & Purchase', {name: 'other_string'})

    template.add_column(sheet, 'Warranty', 'Procurement & Purchase', {name: 'recommended_string'}, {
        :type => :list,
        :formula1 => "lists!#{template.get_lookup_cells('booleans')}",
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => 'Select a value from the list',
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Warranty',
        :prompt => 'Only values in the list are allowed'}, 'default_values', ['YES'])

    template.add_column(sheet, 'Warranty Expiration Date', 'Procurement & Purchase', {name: 'recommended_date'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => earliest_date.strftime("%-m/%d/%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'Warranty Expiration Date',
        :prompt => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}"}, 'default_values', [Date.today.strftime('%m/%d/%Y')])

    template.add_column(sheet, 'In Service Date', 'Operations', {name: 'required_date'}, {
        :type => :whole,
        :operator => :greaterThanOrEqual,
        :formula1 => earliest_date.strftime("%-m/%d/%Y"),
        :showErrorMessage => true,
        :errorTitle => 'Wrong input',
        :error => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}",
        :errorStyle => :stop,
        :showInputMessage => true,
        :promptTitle => 'In Service Date',
        :prompt => "Date must be after #{earliest_date.strftime("%-m/%d/%Y")}"}, 'default_values', [Date.today.strftime('%m/%d/%Y')])

  end


  def post_process(sheet)
    sheet.sheet_view.pane do |pane|
      pane.top_left_cell = "A1"
      pane.state = :frozen_split
      pane.y_split = 2
      pane.x_split = 4
      pane.active_pane = :bottom_right
    end
  end

  def set_columns(asset, cells, columns)
    @add_processing_message = []

    asset.fta_asset_category = FtaAssetCategory.find_by(name: 'Revenue Vehicles')
    asset.serial_number = cells[@vin_column_number[1]]
    asset.asset_tag = cells[@asset_id_column_number[1]]
    asset.external_id = cells[@external_id_column_number[1]]

    asset.fta_asset_class = FtaAssetClass.find_by(name: cells[@class_column_number[1]])
    asset.fta_type = FtaVehicleType.find_by(name: cells[@type_column_number[1]])

    asset_classification =  cells[@subtype_column_number[1]].to_s.split(' - ')
    asset.asset_subtype = AssetSubtype.find_by(name: asset_classification[0], asset_type: AssetType.find_by(name: asset_classification[1]))

    asset.esl_category = EslCategory.find_by(name: cells[@estimated_service_life_category_column_number[1]])

    manufacturer_name = cells[@manufacturer_column_number[1]]
    asset.manufacturer = Manufacturer.find_by(name: manufacturer_name, filter: AssetType.find_by(id: asset.asset_subtype.asset_type_id).class_name)
    if(manufacturer_name == "Other")
      asset.other_manufacturer = cells[@manufacturer_other_column_number[1]]
    end
    model_name = cells[@model_column_number[1]]
    asset.manufacturer_model = ManufacturerModel.find_by(name: model_name)
    if(model_name == "Other")
      asset.other_manufacturer_model = cells[@model_other_column_number[1]]
    end
    chassis_name = cells[@chassis_column_number[1]]
    asset.chassis = Chassis.find_by(name: chassis_name)
    if(chassis_name == "Other")
      asset.other_chassis = cells[@chasis_other_column_number[1]]
    end
    asset.manufacture_year = cells[@year_of_manufacture_column_number[1]]
    fuel_type_name = cells[@fuel_type_column_number[1]]
    asset.fuel_type = FuelType.find_by(name: fuel_type_name)

    if(fuel_type_name == "Other")
      asset.other_fuel_type = cells[@fuel_type_other_column_number[1]]
    end


    # asset.dual_fuel_type = DualFuelType.find_by(name: cells[@dual_fuel_type_column_number[1]])


    asset.vehicle_length = cells[@length_column_number[1]]

    length_unit = cells[@length_units_column_number[1]].downcase

    if(length_unit != 'foot' && length_unit != 'inch' && !Uom.valid?(length_unit))
      @add_processing_message <<  [2, 'warning', "Incompatible length provided #{length_unit} defaulting to foot. for vehicle with Asset Tag #{asset.asset_tag}"]
      length_unit = "foot"
    end

    asset.vehicle_length_unit = length_unit
    asset.gross_vehicle_weight = cells[@gross_vehicle_weight_column_number[1]]
    asset.gross_vehicle_weight_unit = "pound"
    asset.seating_capacity = cells[@seating_capacity_column_number[1]]
    asset.standing_capacity = cells[@standing_capacity_column_number[1]]
    asset.ada_accessible = cells[@ada_accessible_column_number[1]].upcase == 'YES'
    asset.wheelchair_capacity = cells[@wheelchair_capacity_column_number[1]]
    lift_ramp_manufacturer = cells[@lift_ramp_manufacturer_column_number[1]]
    asset.ramp_manufacturer = RampManufacturer.find_by(name: lift_ramp_manufacturer)
    if(lift_ramp_manufacturer == "Other")
      asset.other_ramp_manufacturer = cells[@lift_ramp_manufacturer_other_column_number[1]]
    end

    # Lchang provided
    (1..4).each do |grant_purchase_count|
      if cells[eval("@program_#{grant_purchase_count}_column_number")[1]].present? && cells[eval("@percent_#{grant_purchase_count}_column_number")[1]].present?
        grant_purchase = asset.grant_purchases.build
        grant_purchase.sourceable = FundingSource.find_by(name: cells[eval("@program_#{grant_purchase_count}_column_number")[1]])
        grant_purchase.pcnt_purchase_cost = cells[eval("@percent_#{grant_purchase_count}_column_number")[1]].to_i
      end
    end

    asset.purchase_cost = cells[@cost_purchase_column_number[1]]

    asset.fta_funding_type = FtaFundingType.find_by(name: cells[@funding_type_column_number[1]])

    if (cells[@direct_capital_responsibility_column_number[1]].upcase == 'YES')
      asset.pcnt_capital_responsibility = cells[@percent_capital_responsibility_column_number[1]].to_i
    end

    ownership_type_name = cells[@ownership_type_column_number[1]]
    asset.fta_ownership_type = FtaOwnershipType.find_by(name: ownership_type_name)
    if(ownership_type_name == "Other")
      asset.other_ownership_type = cells[@ownership_type_other_column_number[1]]
    end
    asset.purchased_new = cells[@purchased_new_column_number[1]].upcase == 'YES'
    asset.purchase_date = cells[@purchase_date_column_number[1]]
    asset.contract_num = cells[@contract_purchase_order_column_number[1]]
    asset.contract_type = ContractType.find_by(name: cells[@contract_purchase_order_column_number[1]])
    vendor_name = cells[@vendor_column_number[1]]
    asset.vendor = Vendor.find_by(name: vendor_name)
    if(vendor_name == 'Other')
      asset.other_vendor = cells[@vendor_other_column_number[1]]
    end

    if(!cells[@warranty_column_number[1]].nil? && cells[@warranty_column_number[1]].upcase == 'YES')
      asset.has_warranty = cells[@warranty_column_number[1]].upcase == 'YES'
      asset.warranty_date = cells[@warranty_expiration_date_column_number[1]]
    else
      asset.has_warranty = false
    end


    operator_name = cells[@operator_column_number[1]]
    asset.operator = Organization.find_by(name: operator_name)
    if(operator_name == 'Other')
      asset.other_operator = cells[@operator_other_column_number[1]]
    end
    asset.in_service_date = cells[@in_service_date_column_number[1]]
    # TODO make this work better
    # asset.vehicle_features = cells[@features_column_number[1]]
    priamry_mode_type_string = cells[@priamry_mode_column_number[1]].to_s.split(' - ')[1]
    asset.primary_fta_mode_type = FtaModeType.find_by(name: priamry_mode_type_string)
    asset.primary_fta_service_type = FtaServiceType.find_by(name: cells[@service_type_primary_mode_column_number[1]])

    secondary_mode_type_string = cells[@supports_another_mode_column_number[1]].to_s.split(' - ')[1]
    unless secondary_mode_type_string.nil?
      asset.secondary_fta_mode_type = FtaModeType.find_by(name: secondary_mode_type_string)
    end

    unless cells[@service_type_supports_another_mode_column_number[1]].nil?
      asset.secondary_fta_service_type = FtaServiceType.find_by(name: cells[@service_type_supports_another_mode_column_number[1]])
    end

    asset.dedicated = cells[@dedicated_asset_column_number[1]].upcase == 'YES'
    asset.license_plate = cells[@plate_number_column_number[1]]
    asset.title_number = cells[@title_number_column_number[1]]

    title_owner_name = cells[@title_owner_column_number[1]]
    unless title_owner_name.nil?
      asset.title_ownership_organization = Organization.find_by(name: title_owner_name)
      if(title_owner_name == 'Other')
        asset.other_title_ownership_organization = cells[@title_owner_other_column_number[1]]
      end
    end

    lienholder_name = cells[@lienholder_column_number[1]]
    unless lienholder_name.nil?
      asset.lienholder = Organization.find_by(name: lienholder_name)
      if(lienholder_name == 'Other')
        asset.other_lienholder = cells[@lienholder_other_column_number[1]]
      end
    end

  end

  def set_events(asset, cells, columns)
    @add_processing_message = []

    unless(cells[@odometer_reading_column_number[1]].nil? || cells[@date_last_odometer_reading_column_number[1]].nil?)
      m = MileageUpdateEventLoader.new
      m.process(asset, [cells[@odometer_reading_column_number[1]], cells[@date_last_odometer_reading_column_number[1]]] )

      event = m.event
      if event.valid?
        event.save
      else
        @add_processing_message <<  [2, 'info', "Mileage Event for vehicle with Asset Tag #{asset.asset_tag} failed validation"]
      end

    end

    unless(cells[@condition_column_number[1]].nil? || cells[@date_last_condition_reading_column_number[1]].nil?)
      c = ConditionUpdateEventLoader.new
      c.process(asset, [cells[@condition_column_number[1]], cells[@date_last_condition_reading_column_number[1]]] )

      event = c.event
      if event.valid?
        event.save
      else
        @add_processing_message <<  [2, 'info', "Condition Event for vehicle with Asset Tag #{asset.asset_tag} failed validation"]
      end
    end

    unless cells[@rebuild_rehabilitation_total_cost_column_number[1]].nil? ||
           (cells[@rebuild_rehabilitation_extend_useful_life_miles_column_number[1]].nil? && cells[@rebuild_rehabilitation_extend_useful_life_months_column_number[1]].nil?) ||
           cells[@date_of_rebuild_rehabilitation_column_number[1]].nil?
      r = RebuildRehabilitationUpdateEventLoader.new
      cost = cells[ @rebuild_rehabilitation_total_cost_column_number[1]]
      months = cells[@rebuild_rehabilitation_extend_useful_life_months_column_number[1]]
      miles = cells[@rebuild_rehabilitation_extend_useful_life_miles_column_number[1]]
      r.process(asset, [cost, months, miles, cells[@date_of_rebuild_rehabilitation_column_number[1]]] )

      event = r.event
      if event.valid?
        event.save
      else
        @add_processing_message <<  [2, 'info', "Rebuild Event for vehicle with Asset Tag #{asset.asset_tag} failed validation"]
      end

    end


    unless(cells[@service_status_column_number[1]].nil? || cells[@date_of_last_service_status_column_number[1]].nil?)
      s= ServiceStatusUpdateEventLoader.new
      s.process(asset, [cells[@service_status_column_number[1]], cells[@date_of_last_service_status_column_number[1]]] )

      event = s.event
      if event.valid?
        event.save
      else
        @add_processing_message <<  [2, 'info', "Status Event for vehicle with Asset Tag #{asset.asset_tag} failed validation"]
      end

    end
  end

  def column_widths
    if @organization
      [20] + [30] + [20] * 48
    else
      [30] + [20] * 49
    end

  end

  def worksheet_name
    'Infra - Power.Signal Components'
  end

  def set_initial_asset(cells)
    asset = RevenueVehicle.new
    asset_classification =  cells[@subtype_column_number[1]].to_s.split(' - ')
    asset.asset_subtype = AssetSubtype.find_by(name: asset_classification[0], asset_type: AssetType.find_by(name: asset_classification[1]))
    asset.asset_tag = cells[@asset_id_column_number[1]]

    asset
  end

  def get_messages_to_process
    @add_processing_message
  end

  private

  def initialize(*args)
    super

    # Define sections
    @identificaiton_and_classification_column_number = RubyXL::Reference.ref2ind('A1')
    @characteristics_column_number = RubyXL::Reference.ref2ind('I1')
    @funding_column_number = RubyXL::Reference.ref2ind('AB1')
    @procurement_and_purchase_column_number = RubyXL::Reference.ref2ind('AP1')
    @operations_column_number = RubyXL::Reference.ref2ind('AX1')
    @registration_and_title_column_number = RubyXL::Reference.ref2ind('BG1')
    @initial_event_data_column_number = RubyXL::Reference.ref2ind('BM1')
    @last_known_column_number = RubyXL::Reference.ref2ind('BV1')

    # Define light green columns
    @agency_column_number = RubyXL::Reference.ref2ind('A2')
    @asset_id_column_number = RubyXL::Reference.ref2ind('B2')
    @component_id_column_number = RubyXL::Reference.ref2ind('C2')
    @component_sub_component_column_number = RubyXL::Reference.ref2ind('D2')

    @fixed_signals_signals_description_column_number = RubyXL::Reference.ref2ind('E2')
    @fixed_signals_signals_year_of_construction_column_number = RubyXL::Reference.ref2ind('F2')
    @fixed_signals_signals_manufacturer_column_number = RubyXL::Reference.ref2ind('G2')
    @fixed_signals_signals_model_column_number = RubyXL::Reference.ref2ind('H2')
    @fixed_signals_signals_signal_type_column_number = RubyXL::Reference.ref2ind('I2')

    @fixed_signals_mounting_description_column_number = RubyXL::Reference.ref2ind('J2')
    @fixed_signals_mounting_year_of_construction_column_number = RubyXL::Reference.ref2ind('K2')
    @fixed_signals_mounting_manufacturer_column_number = RubyXL::Reference.ref2ind('L2')
    @fixed_signals_mounting_model_column_number = RubyXL::Reference.ref2ind('M2')
    @fixed_signals_mounting_mounting_type_column_number = RubyXL::Reference.ref2ind('N2')

    @signal_house_description_column_number = RubyXL::Reference.ref2ind('O2')
    @signal_house_year_of_construction_column_number = RubyXL::Reference.ref2ind('P2')

    @program_1_column_number = RubyXL::Reference.ref2ind('Q2')
    @percent_1_column_number = RubyXL::Reference.ref2ind('R2')
    @program_2_column_number =	RubyXL::Reference.ref2ind('S2')
    @percent_2_column_number = RubyXL::Reference.ref2ind('T2')
    @program_3_column_number = RubyXL::Reference.ref2ind('U2')
    @percent_3_column_number = RubyXL::Reference.ref2ind('V2')
    @program_4_column_number = RubyXL::Reference.ref2ind('W2')
    @percent_4_column_number = RubyXL::Reference.ref2ind('X2')
    @cost_purchase_column_number = RubyXL::Reference.ref2ind('Y2')

    @purchased_new_column_number = RubyXL::Reference.ref2ind('Z2')
    @purchase_date_column_number = RubyXL::Reference.ref2ind('AA2')
    @contract_purchase_order_column_number = RubyXL::Reference.ref2ind('AB2')
    @contract_po_type_column_number = RubyXL::Reference.ref2ind('AC2')
    @vendor_column_number = RubyXL::Reference.ref2ind('AD2')
    @vendor_other_column_number = RubyXL::Reference.ref2ind('AE2')
    @warranty_column_number = RubyXL::Reference.ref2ind('AF2')
    @warranty_expiration_date_column_number = RubyXL::Reference.ref2ind('AG2')
    @in_service_date_column_number = RubyXL::Reference.ref2ind('AH2')

  end


end