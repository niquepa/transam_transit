require 'rails_helper'

describe "assets/_rail_car_form.html.haml", :type => :view do
  it 'fields' do
    allow(controller).to receive(:current_user).and_return(create(:admin))
    assign(:organization, create(:organization))
    assign(:asset, RailCar.new)
    render

    expect(rendered).to have_xpath('//input[@id="asset_asset_type_id"]')
    expect(rendered).to have_xpath('//input[@id="asset_asset_subtype_id"]')
    expect(rendered).to have_xpath('//input[@id="asset_organization_id"]')
    expect(rendered).to have_field("asset_asset_tag")
    expect(rendered).to have_field("asset_external_id")
    expect(rendered).to have_field("asset_manufacturer_id")
    expect(rendered).to have_field("asset_manufacturer_model")
    expect(rendered).to have_field("asset_manufacture_year")
    expect(rendered).to have_field("asset_title_number")
    expect(rendered).to have_field("asset_title_owner_organization_id")
    expect(rendered).to have_field("asset_fuel_type_id")
    expect(rendered).to have_field("asset_vehicle_length")
    expect(rendered).to have_field('asset_seating_capacity')
    expect(rendered).to have_field('asset_standing_capacity')
    expect(rendered).to have_field('asset_wheelchair_capacity')
    expect(rendered).to have_field('asset_vehicle_feature_ids_1')
    expect(rendered).to have_field("asset_rebuild_year")
    expect(rendered).to have_field("asset_purchase_cost")
    expect(rendered).to have_field('asset_purchase_date')
    expect(rendered).to have_field('asset_warranty_date')
    expect(rendered).to have_field('asset_in_service_date')
    expect(rendered).to have_field('asset_purchased_new_true')
    expect(rendered).to have_field('vendor_name')
    expect(rendered).to have_field('asset_ada_accessible_lift')
    expect(rendered).to have_field('asset_ada_accessible_ramp')
    expect(rendered).to have_field("asset_fta_emergency_contingency_fleet")
    expect(rendered).to have_field('asset_fta_funding_type_id')
    expect(rendered).to have_field('asset_fta_vehicle_type_id')
    expect(rendered).to have_field('asset_fta_mode_type_ids')
    expect(rendered).to have_field('asset_fta_service_type_ids_1')
    expect(render)
    expect(rendered).to have_field('asset_fta_ownership_type_id')
    expect(rendered).to have_field('asset_parent_id')
  end
end
