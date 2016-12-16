require 'test_helper'

class Admin::CategoryFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_categories_path

    assert has_text? "Categories"
  end

  test "should create new category" do
    visit admin_categories_path
    category_name = "Test Category"
    category_description = "Test description"

    fill_in "Name", with: category_name
    fill_in "Description", with: category_description
    click_on "Create Category"

    assert has_text? category_name
    # assert has_text? category_description
  end

  test "should create new subcategory" do
    parent_category = categories(:wheels)
    visit admin_categories_path
    category_name = "Test Category"

    fill_in "Name", with: category_name
    select parent_category.name, from: "Parent"
    click_on "Create Category"

    assert has_text? category_name
  end

  test "should show a categories page" do
    category = categories(:wheels)
    visit admin_category_path(category)

    assert has_text? "Category"
  end

  test "should edit category" do
    category = categories(:wheels)
    visit edit_admin_category_path(category)

    assert has_text? "Editing Category"
    # TODO add edit steps here
  end

  # test "should destroy category" do
  #
  # end
end
