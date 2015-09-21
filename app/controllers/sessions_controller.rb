class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new,:create,:destroy]
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        session[:current_user_id] = user.id
        user_type = User.find_by_id(session[:current_user_id]).user_type
        if user_type == "U"
          respond_to do |format|
            format.html{ redirect_to user_home_path, notice: "User logged in successfully"}
          end
        else
          respond_to do |format|
            format.html{redirect_to admin_home_path, notice: "Admin logged in successfully"}
          end
        end
      else
        respond_to do |format|
          format.html{ redirect_to login_path, notice: "Email/Password is invalid"}
        end
      end
    end

  def destroy
    session[:current_user_id]=nil
    respond_to do |format|
      format.html{redirect_to login_path, notice: "Signed out successfully"}
    end
  end

end
