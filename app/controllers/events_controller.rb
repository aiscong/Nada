class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :sign_in_user
    #total decimal, name string, note text
    
    # t.integer  "creditor_id", t.integer  "debtor_id"
  def create
    @event = Event.new(:total => params[:total], :note => params[:note], :name => params[:name])
    #rawString = params[:bills]
    bills = Json.parse(params[:bills])
    bills.each do 
    end
    @event.save
      render :json => {message: "Successfully created event"}, status: :ok and return
  end
  
  def destroy
    
  end
  
  private
    def sign_in_user
      cur_user_id = params[:cur_user_id]
      if not cur_user_id
        render :json => {message: 'Missing current user id'}, status: :bad_request and return
      end
      cur_user = User.find_by_id(params[:cur_user_id])
      unless cur_user.present?
        render :json => {message: 'Unable to find current user'}, status: :bad_request and return
      end
      if cur_user.sign_in(params[:password]) == false
        render :json => {message: 'Wrong password'}, status: :bad_request and return
      end
      @cur_user = cur_user
    end
  
end
