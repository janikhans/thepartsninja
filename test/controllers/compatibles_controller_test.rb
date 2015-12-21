require 'test_helper'

class CompatiblesControllerTest < ActionController::TestCase
  setup do
    @compatible = compatibles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compatibles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compatible" do
    assert_difference('Compatible.count') do
      post :create, compatible: { discovery_id: @compatible.discovery_id, original_id: @compatible.original_id, replaces_id: @compatible.replaces_id, user_id: @compatible.user_id }
    end

    assert_redirected_to compatible_path(assigns(:compatible))
  end

  test "should show compatible" do
    get :show, id: @compatible
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compatible
    assert_response :success
  end

  test "should update compatible" do
    patch :update, id: @compatible, compatible: { discovery_id: @compatible.discovery_id, original_id: @compatible.original_id, replaces_id: @compatible.replaces_id, user_id: @compatible.user_id }
    assert_redirected_to compatible_path(assigns(:compatible))
  end

  test "should destroy compatible" do
    assert_difference('Compatible.count', -1) do
      delete :destroy, id: @compatible
    end

    assert_redirected_to compatibles_path
  end
end
