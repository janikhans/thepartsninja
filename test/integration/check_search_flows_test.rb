require 'test_helper'

class CheckSearchFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "check search should only work for signed_in users" do
    visit check_index_path
    assert has_text? "You need to sign in or sign up before continuing."

    sign_in(@user)
    visit check_index_path
    assert has_field? "search_vehicle_brand"
  end

  test "should correctly show search results" do
    # sign_in(@user)
    # visit search_path
    # perform_search
  end

  def perform_search
    terms = { vehicle_year: 2006,
              vehicle_brand: "Yamaha",
              vehicle_model: "Yz250",
              vehicle_submodel: "-- Base",
              comparing_vehicle_year: 2008,
              comparing_vehicle_brand: "Yamaha",
              comparing_vehicle_model: "Yz250",
              comparing_vehicle_submodel: "-- Base",
              category_name: "Complete Wheel Assembly" }
    perform_search(terms)
  end

  def perform_search(options = {})
    # TODO fix chosen helper to correclty find these fields
    select_from_chosen options[:vehicle_brand], from: "search_vehicle_brand"
    select_from_chosen options[:vehicle_model], from: "search_vehicle_model"
    select_from_chosen options[:vehicle_submodel], from: "search_vehicle_submodel"
    select_from_chosen options[:vehicle_year],from: "search_vehicle_year"
    select_from_chosen options[:comparing_vehicle_brand], from: "search_comparing_vehicle_brand"
    select_from_chosen options[:comparing_vehicle_model], from: "search_comparing_vehicle_model"
    select_from_chosen options[:comparing_vehicle_submodel], from: "search_comparing_vehicle_submodel"
    select_from_chosen options[:comparing_vehicle_year], from: "search_comparing_vehicle_year"
    select_from_chosen options[:category_name], from: "search_product_type_id"
    click_on "Search"
  end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    find("##{field[:id]}").click
    find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
  end
end
