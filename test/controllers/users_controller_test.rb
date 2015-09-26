require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @admin = users(:two)
  end

  test "should get user home" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    assert_template 'sessions/new'
    post(:create, session: { email: "rohit@ncsu.edu", password: "password" })
    @controller = old_controller
    get "user_home"
    assert_response :success
  end

  test "should get admin home" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    assert_template 'sessions/new'
    post(:create, session: { email: @admin.email, password: "ishantpass" })
    @controller = old_controller
    get "admin_home"
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should not get admin home" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    assert_template 'sessions/new'
    post(:create, session: { email: @user.email, password: "password" })
    @controller = old_controller
    get "admin_home"
    assert_response :redirect
  end

  test "should get index" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    #get 'sessions/new'
    assert_template 'sessions/new'
    post(:create, session: { email: @admin.email, password: "ishantpass" })
    @controller = old_controller
    get :index
    assert_response :redirect
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #test "should create user" do
  #  old_controller = @controller
  # @controller = SessionsController.new
  # get(:new)
  # assert_template 'sessions/new'
  # post(:create, session: { email: @admin.email, password: "ishantpass" })
  # @controller = old_controller
  #  assert_no_difference('User.count') do
  #    post :create, user: @user
  # end
  #end

  test "should not show user" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    #get 'sessions/new'
    assert_template 'sessions/new'
    post(:create, session: { email: @user.email, password: "ishantpass" })
    @controller = old_controller
    get :show, id: @user
    assert_response :redirect
  end

  test "should get edit" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    #get 'sessions/new'
    assert_template 'sessions/new'
    post(:create, session: { email: @admin.email, password: "ishantpass" })
    @controller = old_controller
    get :edit, id: @user
    assert_response :success
  end

  #test "should update user" do
  #  patch :update, id: @user, user: { email: @user.email, name: @user.name,password: 'abc', password_confirmation: 'abc', user_type: @user.user_type }
  #  assert_redirected_to user_path(assigns(:user))
  #end

  test "should destroy user" do
    old_controller = @controller
    @controller = SessionsController.new
    get(:new)
    assert_template 'sessions/new'
    post(:create, session: { email: @admin.email, password: "ishantpass" })
    @controller = old_controller
    assert_no_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end

  end

end
