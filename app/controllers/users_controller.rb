class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation, :user_type]
  # GET /users
  # GET /users.json
  def index
    if !check_if_user
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
    if !check_if_user
      @users = User.where(id: params[:id])
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end
  end

  # GET /users/new
  def new
    if !check_if_user
      @user = User.new
    else
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "Access to requested link is denied" }
      end
    end

  end

  # GET /users/1/edit
  def edit
    if check_if_user
      puts "Params : " + params[:id].to_s
      puts "Session : " + User.find_by_id(session[:current_user_id]).id.to_s
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
    if ['A','P'].include?(user_params[:user_type])
      if session[:current_user_id].nil?
        respond_to do |format|
          format.html{redirect_to login_path, notice: "Only logged in admins can add new admins"}
        end
      elsif check_if_user
        respond_to do |format|
          format.html{redirect_to user_home_path, notice: "No sufficient permissions to add admin"}
        end
      end
    elsif  user_params[:user_type] == 'U' && !(session[:current_user_id].nil?)
      respond_to do |format|
        format.html{redirect_to user_home_path, notice: "No sufficient permissions to add new users"}
      end
    else
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if ['A','P'].include?(user_params[:user_type])
      if session[:current_user_id].nil?
        respond_to do |format|
          format.html{redirect_to login_path, notice: "Only logged in admins can edit admins"}
        end
      elsif check_if_user
        respond_to do |format|
          format.html{redirect_to user_home_path, notice: "No sufficient permissions to edit admin"}
        end
      end
    elsif  user_params[:user_type] == 'U' && !(session[:current_user_id].nil?) && \
           user_params[:email] != User.find_by_id(session[:current_user_id]).email
        respond_to do |format|
          format.html{redirect_to user_home_path, notice: "No sufficient permissions to add new users"}
        end
    else
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def admin_index
    if !check_if_user
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
    if !check_if_user && @user.user_type != "P" && @user.id != User.find_by_id(session[:curent_user_id]).id
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User cannot be deleted or there is no authorization to do so' }
        format.json { head :no_content }
      end
    end
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
      return true if User.find_by_id(session[:current_user_id]).user_type == 'U'
    end

    def check_if_admin
      return true if ['A','P'].include? User.find_by_id(session[:current_user_id]).user_type
    end
    def check_if_pre_configured_admin
      return true if User.find_by_id(session[:current_user_id]).user_type == 'P'
    end

end
