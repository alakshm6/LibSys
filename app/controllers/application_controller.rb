class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Procured help from http://stackoverflow.com/questions/8500350/how-to-allow-access-only-to-logged-in-users-restricting-direct-entry-of-url
  # and
  # http://guides.rubyonrails.org/v2.3.11/action_controller_overview.html
  helper_method :current_user, :signed_in?
  before_action :require_login

  private
  def current_user
    @_current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
  end

  def signed_in?
    current_user != nil
  end

  def require_login
  if !signed_in?
    flash[:error] = "You must be logged in to access this section"
    redirect_to login_path # halts request cycle
   end
  end
end
