require 'test_helper'

class Admin::VehicleTypeFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_vehicle_types_path

    assert has_text? "Vehicle Types"
  end

  test "should create new vehicle type" do
    vehicle_type_name = "Test Vehicle Type"
    visit admin_vehicle_types_path

    fill_in "Name", with: vehicle_type_name
    click_on "Create Vehicle type"

    assert has_text? vehicle_type_name
  end

  test "should show a vehicle types page" do
    vehicle_type = vehicle_types(:motorcycle)
    visit admin_vehicle_types_path

    within "#vehicle_type_#{vehicle_type.id}" do
      click_on "View"
    end

    assert has_text? vehicle_type.name
  end

  # test "should show errors on new vehicle type" do
  #   # currently not setup correctly
  # end

  test "should edit vehicle type" do
    vehicle_type = vehicle_types(:motorcycle)
    visit admin_vehicle_types_path

    within "#vehicle_type_#{vehicle_type.id}" do
      click_on "Edit"
    end

    #do edit steps
  end

  # test "should destroy vehicle_type" do
  #
  # end
end
