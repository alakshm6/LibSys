class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:current_user_id] = user.id
      user_type = User.find_by_id(session[:current_user_id]).user_type
      if user_type == "A"
        respond_to do |format|
          format.html{ redirect_to new_book_path, notice: "Logged in successfully"}
        end
      elsif user_type == 'P'
        respond_to do |format|
          format.html{ redirect_to new_user_path, notice: "Pre configured logged in"}
        end
      else user_type == 'U'
        respond_to do |format|
          format.html{redirect_to new_checkout_history_path, notice: "User logged in"}
        end
      end
    else
      respond_to do |format|
        format.html{ redirect_to login_path, notice: "Pre configured logged in"}
      end
    end
  end

  def destroy
  end

end
