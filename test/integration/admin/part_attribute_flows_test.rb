require 'test_helper'

class Admin::PartAttributeFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_part_attributes_path

    assert has_text? "Part Attributes"
  end

  test "should create new parent part attribute" do
    visit admin_part_attributes_path
    part_attribute_name = "Test Part Attribute"

    fill_in "Name", with: part_attribute_name
    click_on "Create Part attribute"

    assert has_text? part_attribute_name
  end

  test "should create new part subattribute" do
    parent_attribute = part_attributes(:location)
    visit admin_part_attributes_path
    part_attribute_name = "Test Ninja Category"

    fill_in "Name", with: part_attribute_name
    select parent_attribute.name, from: "Parent"
    click_on "Create Part attribute"

    assert has_text? part_attribute_name
  end

  test "should show a part_attributes page" do
    part_attribute = part_attributes(:location)
    visit admin_part_attribute_path(part_attribute)

    assert has_text? "Part Attribute"
  end

  test "should edit part attribute" do
    part_attribute = part_attributes(:location)
    visit edit_admin_part_attribute_path(part_attribute)

    assert has_text? "Editing Part Attribute"
    # TODO add edit steps here
  end

  # test "should destroy part_attribute" do
  #
  # end
end
