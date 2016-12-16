require 'test_helper'

class Admin::PartFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_parts_path

    assert has_text? "Parts"
  end

  # TODO need to select product first
  # test "should create new part" do
  #   visit admin_parts_path
  #   part_note = "Test Part"
  #   part_number = "12345"
  #
  #   fill_in "Note", with: part_note
  #   fill_in "Part number", with: part_number
  #   click_on "Create Part"
  #
  #   # TODO add tests that add attributes
  #
  #   assert has_text? part_note
  #   assert has_text? part_number
  # end

  test "should show a parts page" do
    part = parts(:wheel06yz)
    visit admin_part_path(part)

    assert has_text? "Part: #{part.part_number}"
  end

  test "should edit part attribute" do
    part = parts(:wheel06yz)
    visit edit_admin_part_path(part)

    assert has_text? "Editing Part: #{part.part_number}"
    # TODO add edit steps here
  end

  # test "should destroy part" do
  #
  # end

  # test "should update fitments" do
  #
  # end
end
