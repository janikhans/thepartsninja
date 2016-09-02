require 'test_helper'

class SearchesTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "search should only work for signed_in users" do
    sign_in(@user)
    visit root_url

    perform_basic_search
    assert_equal current_path, search_path
    assert has_text? "Showing results for"

    sign_out
    perform_basic_search
    refute has_text? "Showing results for"
    assert_equal current_path, coming_soon_path
    assert has_text? "COMING SOON!"
  end

  def perform_basic_search
    terms = { year: 2006,
              brand: "Yamaha",
              model: "Yz250",
              part: "Complete Wheel Assembly" }
    perform_search(terms)
  end

  def perform_search(options = {})
    select options[:year], from: "search_year"
    fill_in "search_brand", with: options[:brand]
    fill_in "search_model", with: options[:model]
    fill_in "search_part", with: options[:part]
    click_on "Search"
  end
end
