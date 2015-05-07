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

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user } and return
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :bad_request } and return
      end
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
  
  def pushReminder
    
    gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
    message = params[:creditor_name] + " reminds you to pay the bill of amount $" + Bill.find_by_id(params[:bill_id]).amount.round(2).to_s
    reg_ids = [params[:c_rid], params[:d_rid]]
    options = {
      data: {
          title: "Reminder",
          body:  message
      }
    }
    response = gcm.send(reg_ids, options)
    render :json => {message: "successfully sent"}, status: :ok and return
  end

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
