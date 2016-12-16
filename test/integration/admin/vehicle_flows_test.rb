require 'test_helper'

class Admin::VehicleFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should show index" do
    visit admin_vehicles_path
    assert has_text? "Vehicles"
  end

  test "should create new vehicle model" do
    vehicle_brand = "Test Brand"
    vehicle_model_name = "Test Vehicle Model"
    vehicle_submodel_name = "Test Vehicle Submodel"
    visit admin_vehicles_path

    click_on "Single Vehicle"

    fill_in "Brand", with: vehicle_brand
    fill_in "Model", with: vehicle_model_name
    fill_in "Submodel", with: vehicle_submodel_name
    select "2017", from: "Year"
    click_on "Create Vehicle"

    assert has_text? vehicle_model_name
    assert has_text? vehicle_submodel_name
    assert has_text? vehicle_brand
  end

  test "should show errors on new vehicle model" do
    vehicle_brand = brands(:yamaha)
    vehicle_model_name = "Test Vehicle Model"
    visit admin_vehicles_path

    click_on "Single Vehicle"

    click_on "Create Vehicle"
    assert has_text? "can't be blank", count: 2

    fill_in "Brand", with: vehicle_brand.name
    fill_in "Model", with: vehicle_model_name
    click_on "Create Vehicle"

    assert has_text? vehicle_model_name
  end
end
