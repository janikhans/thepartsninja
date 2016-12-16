require 'test_helper'

class Admin::NinjaCategoryFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_ninja_categories_path

    assert has_text? "Ninja Categories"
  end

  test "should create new ninja category" do
    visit admin_ninja_categories_path
    ninja_category_name = "Test Ninja Category"

    fill_in "Name", with: ninja_category_name
    click_on "Create Ninja category"

    assert has_text? ninja_category_name
  end

  test "should create new ninja subcategory" do
    parent_ninja_category = categories(:wheels)
    visit admin_ninja_categories_path
    ninja_category_name = "Test Ninja Category"

    fill_in "Name", with: ninja_category_name
    select parent_ninja_category.name, from: "Parent"
    click_on "Create Ninja category"

    assert has_text? ninja_category_name
  end

  test "should show a ninja_categories page" do
    ninja_category = categories(:wheels)
    visit admin_ninja_category_path(ninja_category)

    assert has_text? "Ninja Category"
  end

  test "should edit ninja category" do
    ninja_category = categories(:wheels)
    visit edit_admin_ninja_category_path(ninja_category)

    assert has_text? "Editing Ninja Category"
    # TODO add edit steps here
  end

  # test "should destroy ninja_category" do
  #
  # end
end
