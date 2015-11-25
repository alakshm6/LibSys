class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation, :user_type]
  # GET /users
  # GET /users.json
  def index
    if check_if_admin
      @users = User.all
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if check_if_user || check_if_admin
      @users = User.where(id: params[:id])
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
    # Even users who are not logged in can access the form and hence no authorization
  end

  # GET /users/1/edit
  def edit
    if check_if_user
      if params[:id].to_s != User.find_by_id(session[:current_user_id]).id.to_s
        respond_to do |format|
          format.html{redirect_to user_home_path, notice: "No sufficient permissions to edit other users"}
        end
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    if ['A'].include?(user_params[:user_type])
      if session[:current_user_id].nil?
        redirect_to login_path, notice: "Only logged in admins can add new admins"
      elsif check_if_user
        redirect_to user_home_path, notice: "No sufficient permissions to add admin"
      elsif check_if_admin
        @user = User.new(user_params)
        if @user.save
          #Tell the UserMailer to send a welcome email after save
          UserMailer.welcome_email(@user).deliver_later
          redirect_to admin_home_path, notice: 'Admin was successfully created'
        else
          render :new
        end
      end
    elsif ['P'].include?(user_params[:user_type])
      if session[:current_user_id].nil?
        redirect_to login_path, notice: "Preconfigured admin cannot be created"
      elsif check_if_user
        redirect_to user_home_path, notice: "Preconfigured admin cannot be created"
      elsif check_if_admin
        redirect_to admin_home_path, notice: "Preconfigured admin cannot be created"
      end
    elsif ['U'].include?(user_params[:user_type])
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          #Tell the UserMailer to send a welcome email after save
          UserMailer.welcome_email(@user).deliver_later
          if session[:current_user_id].nil?
            format.html { redirect_to login_path, notice: 'User was successfully created.Login to access the system' }
          else
            format.html {redirect_to :back, notice: 'User was successfully created.Login to access the system' }
          end
        else
          format.html { render :new }
        end
    end
    end
    end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if session[:current_user_id].nil?
      if check_if_admin
      redirect_to login_path, notice: "Only logged in admins can edit admins"
      else
        redirect_to login_path, notice: "Only logged in users can edit users"
      end
    end

    if params[:id].to_s != User.find_by_id(session[:current_user_id]).id.to_s
       if check_if_user
        redirect_to user_home_path,notice: "Users do not have permissions to update other users"
      elsif check_if_admin
        redirect_to admin_home_path,notice: "Admins do not have permissions to update other users"
      end
    end

    if ['A','P'].include?(user_params[:user_type]) && check_if_user
        redirect_to user_home_path, notice: "No sufficient permissions to edit admin"
    elsif  user_params[:user_type] == 'U' && check_if_admin
        redirect_to admin_home_path, notice: "No sufficient permissions to edit users"
    elsif user_params[:user_type] == 'P'
      redirect_to admin_home_path, notice: "Preconfigured admin details cannot be updated"
    else
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def admin_index
    if check_if_admin
      @users = User.where(user_type: ['A','P'])
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end
  end
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if check_if_admin
      @checkout_histories=CheckoutHistory.find_by_email(@user.email);
      if @checkout_histories.nil?
      @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end

      else
      @checkout_histories=CheckoutHistory.all
      @checkout_histories.each do |checkout_history|
          if @checkout_histories.last == checkout_history

          puts checkout_history.return_timestamp
          puts DateTime.new(9999,12,31).utc
          puts checkout_history.return_timestamp=='9999-12-31T00:00:00+00:00'


          if !(checkout_history.return_timestamp=='9999-12-31T00:00:00+00:00')
          @user.destroy
          respond_to do |format|
            format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
            format.json { head :no_content }
          end
          else
            respond_to do |format|
              format.html { redirect_to users_path, notice: 'User cannot be destroyed as he has a checked out book.' }
              format.json { head :no_content }
            end
          end
      end
      end
    end
    end
    end

  def delete_admin
if check_if_admin
      @user=User.find_by_id(params[:id])
      @checkout_histories=CheckoutHistory.find_by_email(@user.email);
      if @checkout_histories.nil?
      @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_index_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end

      else
      @checkout_histories=CheckoutHistory.all
      @checkout_histories.each do |checkout_history|
          if @checkout_histories.last == checkout_history

          puts checkout_history.return_timestamp
          puts DateTime.new(9999,12,31).utc
          puts checkout_history.return_timestamp=='9999-12-31T00:00:00+00:00'


          if !(checkout_history.return_timestamp=='9999-12-31T00:00:00+00:00')
@user.destroy
          respond_to do |format|
            format.html { redirect_to admin_index_path, notice: 'User was successfully destroyed.' }
            format.json { head :no_content }
          end
          else
            respond_to do |format|
              format.html { redirect_to admin_index_path, notice: 'User cannot be destroyed as he has a checked out book.' }
              format.json { head :no_content }
            end
          end
      end
      end
    end
    end

end

  def history
    @user = User.find(params[:id])
  end

  def admin_home
    if !check_if_user
      @users = User.where(user_type: ['A','P'])
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end
  end

  def user_home
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password,:password_confirmation, :user_type)
    end

    def check_if_user
      return true if ['U'].include? User.find_by_id(session[:current_user_id]).user_type
    end

    def check_if_admin
      return true if ['A','P'].include? User.find_by_id(session[:current_user_id]).user_type
    end
    def check_if_pre_configured_admin
      return true if User.find_by_id(session[:current_user_id]).user_type == 'P'
    end
end

