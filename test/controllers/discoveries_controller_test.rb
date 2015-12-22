require 'test_helper'

class DiscoveriesControllerTest < ActionController::TestCase
  setup do
    @discovery = discoveries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discoveries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discovery" do
    assert_difference('Discovery.count') do
      post :create, discovery: { comment: @discovery.comment, modifications: @discovery.modifications, user_id: @discovery.user_id }
    end

    assert_redirected_to discovery_path(assigns(:discovery))
  end

  test "should show discovery" do
    get :show, id: @discovery
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discovery
    assert_response :success
  end

  test "should update discovery" do
    patch :update, id: @discovery, discovery: { comment: @discovery.comment, modifications: @discovery.modifications, user_id: @discovery.user_id }
    assert_redirected_to discovery_path(assigns(:discovery))
  end

  test "should destroy discovery" do
    assert_difference('Discovery.count', -1) do
      delete :destroy, id: @discovery
    end

    assert_redirected_to discoveries_path
  end
end
