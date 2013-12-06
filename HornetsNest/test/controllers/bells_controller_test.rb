require 'test_helper'

class BellsControllerTest < ActionController::TestCase
  setup do
    @bell = bells(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bells)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bell" do
    assert_difference('Bell.count') do
      post :create, bell: { name: @bell.name }
    end

    assert_redirected_to bell_path(assigns(:bell))
  end

  test "should show bell" do
    get :show, id: @bell
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bell
    assert_response :success
  end

  test "should update bell" do
    patch :update, id: @bell, bell: { name: @bell.name }
    assert_redirected_to bell_path(assigns(:bell))
  end

  test "should destroy bell" do
    assert_difference('Bell.count', -1) do
      delete :destroy, id: @bell
    end

    assert_redirected_to bells_path
  end
end
