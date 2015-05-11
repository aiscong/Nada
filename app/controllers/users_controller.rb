require 'gcm'
class UsersController < ApplicationController
  protect_from_forgery
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully updated' }
        format.json { 
           render :show, status: :created, location: @user
        }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :bad_request }
      end
    end
  end
  
  def update_reg_id
    @user = User.find(params[:id])
    unless @user.authenticate(params[:password])
      render :json => { message: 'Password not correct'}, status: :bad_request and return
    end
    if @user.update_attribute(:reg_id, params[:reg_id])
      render :json => {message: 'Successfully updated register ID'}, status: :ok and return
    else
      render :json => {message: 'Failed to update register ID'}, status: :bad_request and return
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    unless @user.authenticate(params[:old_password])
      render :json => { message: 'Original password not correct'}, status: :bad_request and return
    end
    
    if @user.update_attribute(:name, params[:name]) and @user.update_attribute(:password, params[:password])
      render :show
    else
      render :json => {message: 'Failed to update user info'}, status: :bad_request and return
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content, status: :ok }
    end
  end
  
  # POST /authenticate
  def authenticate
    email = params[:email]
    password = params[:password]
    if not email or not password
      render :json => {response:'Missing email or password'}, :status => :bad_request and return
    end

    user = User.find_by_email(email)
    #password = @json['password']

    unless user.present?
      render :json => {message: 'User not found with that email'}, status: :bad_request and return
    end
    
    unless user.authenticate(password)
      render :json => {message: 'Invalid password for user'}, status: :bad_request and return
    end
    @user = user
    render :show
  end
  
  def searchUser
    email = params[:email]
    if not email
      render :json => {response: 'Missing email'}, :status => :bad_request and return
    end
    user = User.find_by_email(email)
    unless user.present?
      render :json => {message: 'User not found with that email'}, status: :bad_request and return
    end
    @user = user
    render :show
  end
  


#  def activity
 #   @user = User.find_by_id(params[:id])
  #  unless @user.authenticate(params[:password])
   #   render :json => {message: 'Wrong password'}
  #  end
   # @activity = Array.new
  #  @activities = Array.new
   # @activity.push(@user.unpaid_bills)
  #  @activity.push(@user.unrec_bills)
  #  @activity.each do |act|
  #    act = act.becomes(Bill)
   # end
  #  @activities.sort
  #end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
