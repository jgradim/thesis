require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:versions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create version" do
    assert_difference('Version.count') do
      post :create, :version => { }
    end

    assert_redirected_to version_path(assigns(:version))
  end

  test "should show version" do
    get :show, :id => versions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => versions(:one).to_param
    assert_response :success
  end

  test "should update version" do
    put :update, :id => versions(:one).to_param, :version => { }
    assert_redirected_to version_path(assigns(:version))
  end

  test "should destroy version" do
    assert_difference('Version.count', -1) do
      delete :destroy, :id => versions(:one).to_param
    end

    assert_redirected_to versions_path
  end
end
