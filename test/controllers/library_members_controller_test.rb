require 'test_helper'

class LibraryMembersControllerTest < ActionController::TestCase
  setup do
    @library_member = library_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:library_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create library_member" do
    assert_difference('LibraryMember.count') do
      post :create, library_member: { email: @library_member.email, encrypted_password: @library_member.encrypted_password, name: @library_member.name, salt: @library_member.salt }
    end

    assert_redirected_to library_member_path(assigns(:library_member))
  end

  test "should show library_member" do
    get :show, id: @library_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @library_member
    assert_response :success
  end

  test "should update library_member" do
    patch :update, id: @library_member, library_member: { email: @library_member.email, encrypted_password: @library_member.encrypted_password, name: @library_member.name, salt: @library_member.salt }
    assert_redirected_to library_member_path(assigns(:library_member))
  end

  test "should destroy library_member" do
    assert_difference('LibraryMember.count', -1) do
      delete :destroy, id: @library_member
    end

    assert_redirected_to library_members_path
  end
end
