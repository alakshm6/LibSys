require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def set_user
    @user= User.new(name: 'Rohit sharma', email: 'rohitsharma@gmail.com' , password: "rohitpass", user_type: 'U' , password_confirmation: "rohitpass")
  end


  test "no type except UPA" do
    set_user
    assert_match /[UPA]/ , @user.user_type , "User Type should be U, P or A"
  end

  test "length of user name" do
    set_user
    if @user.name.length>2 && @user.name.length <=50
      assert true
    else
      assert false
    end
  end


  test "format of email" do
    set_user
    assert_match /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i,@user.email,"Email Format not proper"
  end

  test "unique email" do
    set_user
    @user.save
    assert User.where(:email => @user.email).count == 1
  end

  test "password length" do
    set_user
    if @user.password.length>0 && @user.password.length <=72
      assert true
    else
      assert false
    end
  end

  test "wrong password confirmatiom" do
    set_user
    @user.save
    if  @user.password == @user.password_confirmation
      assert true
    else
      assert false
    end

  end

end