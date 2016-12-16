require 'test_helper'

class Admin::EbayCategoryFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_ebay_categories_path

    assert has_text? "Ebay Categories"
  end

  test "should create new ebay category" do
    ebay_category = categories(:ebay_category_one)
    visit admin_ebay_categories_path
    ebay_category_name = "Test Category"

    fill_in "Name", with: ebay_category_name
    select ebay_category.name, from: "Parent"
    click_on "Create Ebay category"

    assert has_text? ebay_category_name
  end

  test "should show a ebay_categories page" do
    ebay_category = categories(:ebay_category_one)
    visit admin_ebay_category_path(ebay_category)

    assert has_text? "Ebay Category"
  end

  test "should edit ebay category" do
    ebay_category = categories(:ebay_category_one)
    visit edit_admin_ebay_category_path(ebay_category)

    assert has_text? "Editing Ebay Category"
    # TODO add edit steps here
  end

  # test "should destroy ebay_category" do
  #
  # end
end
