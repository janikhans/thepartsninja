require 'test_helper'

class Admin::FitmentNoteFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_fitment_notes_path

    assert has_text? "Fitment Notes"
  end

  test "should create new fitment note" do
    parent_note = fitment_notes(:location)
    visit admin_fitment_notes_path
    fitment_note_name = "Test Note"

    fill_in "Name", with: fitment_note_name
    select parent_note.name, from: "Parent"
    click_on "Create Fitment note"

    assert has_text? fitment_note_name
  end

  test "should show a fitment notes page" do
    fitment_note = fitment_notes(:location)
    visit admin_fitment_note_path(fitment_note)

    assert has_text? "Fitment Note"
  end

  test "should edit fitment note" do
    fitment_note = fitment_notes(:location)
    visit edit_admin_fitment_note_path(fitment_note)

    assert has_text? "Editing Fitment Note"
    # TODO add edit steps here
  end

  # test "should destroy fitment_note" do
  #
  # end
end
