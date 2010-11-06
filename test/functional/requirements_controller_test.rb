require 'test_helper'

class callingsControllerTest < ActionController::TestCase
  setup do
    @calling = callings(:one)
    current_user = users(:quentin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:callings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create calling" do
    assert_difference('calling.count') do
      post :create, :calling => @calling.attributes
    end

    assert_redirected_to calling_path(assigns(:calling))
  end

  test "should show calling" do
    get :show, :id => @calling.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @calling.to_param
    assert_response :success
  end

  test "should update calling" do
    put :update, :id => @calling.to_param, :calling => @calling.attributes
    assert_redirected_to calling_path(assigns(:calling))
  end

  test "should destroy calling" do
    assert_difference('calling.count', -1) do
      delete :destroy, :id => @calling.to_param
    end

    assert_redirected_to callings_path
  end
end
