class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :sign_in_user

  def create
    @event = Event.new(:total => params[:total], :note => params[:note], :name => params[:name])
    @event.save
    #rawString = params[:bills]
    bs = params[:bills]
    bs.each do |b|
       #render :json => {message: params[:creditor_id]}, status: :ok and return
       bill = @event.bills.create(creditor_id: params[:creditor_id], 
          debtor_id: b["debtor_id"], 
          amount: b["amount"])
       bill.save
    end
    @bills = @event.bills
    render :show
  end
  
  def update
    event = Event.find_by_id(params[:id])
    
    unless event.present?
      render :json => {message: 'Unable to find the Event'}, status: :bad_request and return
    end
    @event = event
    if @event.update_attribute(:name, params[:name]) and @event.update_attribute(:note, params[:note])
      render :show
    else
      render :json => {message: 'failed to update the event'}, status: :bad_request and return
    end 
  end
  
  def destroy
    @event.destroy
    render :json => {message: "Successfully deleted Event"}, status: :ok and return
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
