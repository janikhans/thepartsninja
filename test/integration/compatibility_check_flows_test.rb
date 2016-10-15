require 'test_helper'

class CompatibilityCheckFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "compatibility check should only work for signed_in users" do
    visit compatibility_check_path
    assert has_text? "You need to sign in or sign up before continuing."

    sign_in(@user)
    visit compatibility_check_path
    assert has_field? "compatibility_check_vehicle_one_brand"
  end

  test "should correctly show compatibility_check results" do
    # sign_in(@user)
    # visit compatibility_check_path
    # perform_compatibility_check
  end

  def perform_compatibility_check
    terms = { vehicle_one_year: 2006,
              vehicle_one_brand: "Yamaha",
              vehicle_one_model: "Yz250",
              vehicle_one_submodel: "-- Base",
              vehicle_two_year: 2008,
              vehicle_two_brand: "Yamaha",
              vehicle_two_model: "Yz250",
              vehicle_two_submodel: "-- Base",
              product_type_category: "Motorcycle Parts",
              product_type_subcategory: "Wheels",
              product_type: "Complete Wheel Assembly" }
    perform_search(terms)
  end

  def perform_search(options = {})
    # TODO fix chosen helper to correclty find these fields
    select_from_chosen options[:vehicle_one_brand], from: "compatibility_check_vehicle_one_brand"
    select_from_chosen options[:vehicle_one_model], from: "compatibility_check_vehicle_one_model"
    select_from_chosen options[:vehicle_one_submodel], from: "compatibility_check_vehicle_one_submodel"
    select_from_chosen options[:vehicle_one_year],from: "compatibility_check_vehicle_one_year"
    select_from_chosen options[:vehicle_two_brand], from: "compatibility_check_vehicle_two_brand"
    select_from_chosen options[:vehicle_two_model], from: "compatibility_check_vehicle_two_model"
    select_from_chosen options[:vehicle_two_submodel], from: "compatibility_check_vehicle_two_submodel"
    select_from_chosen options[:vehicle_two_year], from: "compatibility_check_vehicle_two_year"
    select_from_chosen options[:product_type_category], from: "compatibility_check_category_parent"
    select_from_chosen options[:product_type_subcategory], from: "compatibility_check_category_subcategories"
    select_from_chosen options[:product_type], from: "compatibility_check_product_type_id"
    click_on "Search"
  end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    find("##{field[:id]}").click
    find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
  end
end
