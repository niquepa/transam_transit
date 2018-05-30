require 'rails_helper'

describe "assets/_support_facility_form.html.haml", :type => :view do
  it 'fields' do
    assign(:organization, create(:organization))
    assign(:asset, SupportFacility.new)
    render

    expect(rendered).to have_xpath('//input[@id="asset_asset_type_id"]')
    expect(rendered).to have_xpath('//select[@id="asset_asset_subtype_id"]')
    expect(rendered).to have_xpath('//input[@id="asset_organization_id"]')
    expect(rendered).to have_field("asset_asset_tag")
    expect(rendered).to have_field("asset_external_id")
    expect(rendered).to have_field('asset_description')
    expect(rendered).to have_field('asset_address1')
    expect(rendered).to have_field('asset_address2')
    expect(rendered).to have_field('asset_city')
    expect(rendered).to have_field('asset_state')
    expect(rendered).to have_field('asset_zip')
    expect(rendered).to have_field("asset_land_ownership_type_id")
    expect(rendered).to have_field("asset_land_ownership_organization_id")
    expect(rendered).to have_field('asset_building_ownership_type_id')
    expect(rendered).to have_field('asset_building_ownership_organization_id')
    expect(rendered).to have_field("asset_manufacture_year")
    expect(rendered).to have_field("asset_facility_size")
    expect(rendered).to have_field("asset_section_of_larger_facility_true")
    expect(rendered).to have_field("asset_pcnt_operational")
    expect(rendered).to have_field("asset_num_structures")
    expect(rendered).to have_field('asset_num_floors')
    expect(rendered).to have_field('asset_num_parking_spaces_public')
    expect(rendered).to have_field('asset_num_parking_spaces_private')
    expect(rendered).to have_field('asset_lot_size')
    expect(rendered).to have_field("asset_line_number")
    expect(rendered).to have_field("asset_leed_certification_type_id")
    expect(rendered).to have_field("asset_purchase_cost")
    expect(rendered).to have_field('asset_purchase_date')
    expect(rendered).to have_field('asset_warranty_date')
    expect(rendered).to have_field('asset_in_service_date')
    expect(rendered).to have_field('asset_purchased_new_true')
    expect(rendered).to have_field('vendor_name')
    expect(rendered).to have_field('asset_ada_accessible_ramp')
    expect(rendered).to have_field('asset_fta_funding_type_id')
    expect(rendered).to have_field('asset_pcnt_capital_responsibility')
    expect(rendered).to have_field('asset_primary_fta_mode_type_id')
    expect(rendered).to have_field('asset_secondary_fta_mode_type_ids')
    expect(rendered).to have_field('asset_fta_facility_type_id')
    expect(rendered).to have_field('asset_facility_capacity_type_id')
  end
end
