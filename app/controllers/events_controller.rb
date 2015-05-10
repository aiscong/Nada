require 'gcm'
class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :sign_in_user

  def create
    @event = Event.new(:total => params[:total], :note => params[:note], :name => params[:name])
    @event.save
    #rawString = params[:bills]
    gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
    cid = "APA91bErY9xndMim8bFP6Nb0icScpiaUAUSS3R58XgRkJyhXEQVDPN918Ei_3lW4QNKXN
          5YFYpwICLWDV084_ocuTtwTutlXk7KOJt3y8-UXWfQjFdYmQud3-oY2DGpJTyjNXsypi9k7t1Ihuyf4MMUs4Q4tvRxk8w"
    messageCreditor = "You are added in group bill " + @event.name      
    creditor = User.find_by_id(params[:creditor_id])
    reg_ids_creditor = [cid, creditor.reg_id]
    messageCreditor = "You are added in group bill " + @event.name + " receiving $" + 
    @event.total.round(2).to_s
    optionsCreditor = {
      data: {
            title: "Reminder",
            body:  messageCreditor
        }
    }
    response = gcm.send(reg_ids_creditor, optionsCreditor)
    bs = params[:bills]
    bs.each do |b|
      bill = @event.bills.create(creditor_id: params[:creditor_id], 
          debtor_id: b["debtor_id"], 
          amount: b["amount"])
      bill.save
      messageDebtor= "You are added in group bill " + @event.name + " paying $" + 
      bill.amount.round(2).to_s
      debtor = User.find_by_id(bill.debtor_id)
      reg_ids_debtor = [creditor.reg_id, debtor.reg_id]
      optionsDebtor = {
        data: {
            title: "Reminder",
            body:  messageDebtor
        }
      }
      response = gcm.send(reg_ids_debtor, optionsDebtor)
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
