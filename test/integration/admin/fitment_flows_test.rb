require 'test_helper'

class Admin::FitmentFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_fitments_path

    assert has_text? "Fitments"
  end

  # test "should create new fitment note" do
  #   visit admin_fitments_path
  # end

  test "should show a fitment page" do
    fitment = fitments(:wheel06yz250)
    visit admin_fitment_path(fitment)

    assert has_text? "Showing Fitment: #{fitment.id}"
  end

  test "should edit fitment note" do
    fitment = fitments(:wheel06yz250)
    visit edit_admin_fitment_path(fitment)

    assert has_text? "Editing Fitment: #{fitment.id}"
    # TODO add edit steps here
  end

  # test "should destroy fitment" do
  #
  # end
end
