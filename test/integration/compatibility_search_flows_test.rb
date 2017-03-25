require 'test_helper'

class CompatibilitySearchFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "compatibility search should only work for signed_in users" do
    visit find_index_path
    assert has_text? "You need to sign in or sign up before continuing."

    sign_in(@user)
    visit find_index_path
    assert has_field? "search_vehicle_brand"
  end

  # test "should correctly show search results" do
  #   sign_in(@user)
  #   visit find_index_path
  #   perform_search
  # end

  def perform_search
    terms = { vehicle_year: 2006,
              vehicle_brand: "Yamaha",
              vehicle_model: "Yz250",
              vehicle_submodel: "-- Base",
              category_name: "Complete Wheel Assembly" }
    perform_search(terms)
  end

  def perform_search(options = {})
    # TODO fix chosen helper to correclty find these fields
    select_from_chosen options[:vehicle_brand], from: "search_vehicle_brand"
    select_from_chosen options[:vehicle_model], from: "search_vehicle_model"
    select_from_chosen options[:vehicle_submodel], from: "search_vehicle_submodel"
    select_from_chosen options[:vehicle_year],from: "search_vehicle_year"
    fill_in "#search_category_name", with: options[:category_name]
    click_on "Find Compatibilities"
  end

  # def select_from_chosen(item_text, options)
  #   field = find_field(options[:from], visible: false)
  #   binding.pry
  #   find("##{field[:id]}").click
  #   find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
  # end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], visible: false)
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('chosen:updated')")
  end
end
