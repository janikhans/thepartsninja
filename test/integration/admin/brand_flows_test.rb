require 'test_helper'

class Admin::BrandFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_brands_path

    assert has_text? "Brands"
  end

  test "should create new brand" do
    visit admin_brands_path
    brand_name = "Test Brand"
    brand_website = "www.brand.com"

    fill_in "Name", with: brand_name
    fill_in "Website", with: brand_website
    click_on "Create Brand"

    assert has_text? brand_name
    assert has_text? brand_website
  end

  test "should show a brands page" do
    brand = brands(:yamaha)
    visit admin_brand_path(brand)
    assert has_text? brand.name
    assert has_text? brand.website
  end

  # test "should show errors on new brand" do
  #   # currently not setup correctly
  # end

  test "should edit brand" do
    brand = brands(:yamaha)
    visit edit_admin_brand_path(brand)
  end
end
