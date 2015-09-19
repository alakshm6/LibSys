class SessionsController < ApplicationController
  def new
  end

  def create
    user = Admin.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      redirect_to root_url
    else
      flash[:danger] = 'email/password is invalid'
      render 'new'
    end
  end

  def destroy
  end

end
