class BillsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :sign_in_user
  def new
    @bill = Bill.new
  end
  def create
    creditor_user = User.find_by_id(params[:creditor_id])
    unless creditor_user.present?
      render :json => {message: 'Failed to find the creditor user'}, status: :bad_request and return
    end
    @creditor_user = creditor_user
    debtor_user = User.find_by_id(params[:debtor_id])
    unless debtor_user.present?
      render :json => {message: 'Failed to find the debtor user'}, status: :bad_request and return
    end
    @debtor_user = debtor_user
    @bill = @debtor_user.unpaid_bills.build(creditor_id: @creditor_user.id, amount: params[:amount])
    if @bill.save
      render :show
    else
      render :json => {message: 'Failed to create the bill'}, status: :bad_request and return
    end
  end
  
  def show
    @bill = Bill.find(params[:id])
  end
  
  def update
    amount = params[:amount]
    if not amount
      render :json => {message: 'Missing new amount'}, status: :bad_request and return
    end
    gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
    updated_msg = "Bill amount got updated from "
    debtor_id = params[:debtor_id]
    if debtor_id and debtor_id == params[:cur_user_id]
      bill = @cur_user.unpaid_bills.find_by_id(params[:id])
      unless bill.present?
        render :json => {message: 'Bill does not belong to this user debtor'}, status: :bad_request and return
      end
      @bill = bill
      if bill.settled == true
        render :json => {message: 'This bill has already been settled'}, status: :bad_request and return
      end
      @event = Event.find_by_id(@bill.event_id)
      newTotal = @event.total - @bill.amount + BigDecimal(amount)
      if @bill.update_attribute(:amount, amount) and @event.update_attribute(:total, newTotal)
        creditor = User.find_by_id(@bill.creditor_id)
        updated_msg = updated_msg + @event.name   
        reg_ids = [creditor.reg_id, @cur_user.reg_id]
        options = {
          data: {
            title: "Reminder",
            body:  updated_msg
          }
        }
        response = gcm.send(reg_ids, options)
        render :show and return
      else
        render :json => {message: 'Update failed'}, status: :bad_request and return
      end
    end
    
    creditor_id = params[:creditor_id]
    if creditor_id and creditor_id == params[:cur_user_id]
      bill = @cur_user.unrec_bills.find_by_id(params[:id])
      unless  bill.present?
        render :json => {message: 'Bill does not belong to this user creditor'}, status: :bad_request and return
      end
      @bill = bill
      if bill.settled == true
        render :json => {message: 'This bill has already been settled'}, status: :bad_request and return
      end
      @event = Event.find_by_id(@bill.event_id)
      newTotal = @event.total - @bill.amount + BigDecimal(amount)
      if @bill.update_attribute(:amount, amount) and @event.update_attribute(:total, newTotal)
        debtor = User.find_by_id(@bill.debtor_id)
        updated_msg = updated_msg + @event.name   
        reg_ids = [debtor.reg_id, @cur_user.reg_id]
        options = {
          data: {
            title: "Reminder",
            body:  updated_msg
          }
        }
        response = gcm.send(reg_ids, options)
        render :show and return
      else
        render :json => {message: 'Update failed'}, status: :bad_request and return
      end
    end
    render :json => {message: 'Invalid operation - Bill update'}, status: :bad_request and return
  end
  
  def settle
    bill = Bill.find_by_id(params[:id])
    unless bill.present?
      render :json => {message: 'Failed to find the bill'}, status: :bad_request and return
    end
    @bill = bill
  

    if @bill.settled?
      render :json =>{message: 'The requested bill has already been settled'}, status: :bad_request and return
    end
    gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
  
    
    @bill.settled = true
    @bill.settled_date = Time.now
    if @bill.save
      @creditor = User.find_by_id(bill.creditor_id)
      @debtor = User.find_by_id(bill.debtor_id)
    
      settled_msg = "Bill from " + Event.find_by_id(@bill.event_id).name + " of amount $" + @bill.amount.round(2).to_s + " is now settled between "  + @creditor.name  + " and "  + @debtor.name
      
      reg_ids = [@debtor.reg_id, @creditor.reg_id]
        
      options = {
          data: {
            title: "Reminder",
            body:  settled_msg
        }
      }
      
      response = gcm.send(reg_ids, options)
    
      render :show, status: :ok and return
    else
      render :json => {message: 'Failed to settle the bill'}, status: :bad_request and return
    end
  end
  
  def destroy
    @bill = Bill.find_by_id(params[:id])
    unless @bill.present?
      render :json => {message: 'Bill not found with this id'}, status: :bad_request and return
    end
    
    cur_user_id = params[:cur_user_id]
    unless @bill.creditor_id != cur_user_id and @bill.debtor_id != cur_user_id
      render :json => {message: 'You cannot destroy bills not related to you'}, status: :bad_request and return
    end
    
    if @bill.destroy
      debtor = User.find_by_id(@bill.debtor_id)
      creditor = User.find_by_id(@bill.creditor_id)
      @event = Event.find_by_id(@bill.event_id)
      gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
      destroy_msg = "Bill got removed from " + @event.name   
      reg_ids = [creditor.reg_id, debtor.reg_id]
      options = {
        data: {
          title: "Reminder",
          body:  destroy_msg
        }
      }
      response = gcm.send(reg_ids, options)
      render :json => {message: 'Successfully destroyed the bill'}, status: :ok and return
    else
      render :json => {message: 'Failed to destroy the bill'}, status: :bad_request and return
    end
  end
  
  def pushReminder
    gcm = GCM.new("AIzaSyBTH6oHacwBoMV03oSH1l9aPHdpmA2LSH8")
   
    bs = params[:bills]
    bs.each do |b|
      bill = Bill.find_by_id(b["id"])
      debtor = User.find_by_id(bill.debtor_id)
      creditor = User.find_by_id(bill.creditor_id)
      event = Event.find_by_id(bill.event_id)
      reg_id = Array.new
      reg_id.push(debtor.reg_id)
      message = creditor.name + " reminds you to pay $" + bill.amount.round(2).to_s + " for " + event.name
      options = {
        data: {
          title: "Reminder",
          body:  message
        }
      }
      response = gcm.send(reg_id, options)
    end
    render :json => {message: "successfully sent"}, status: :ok and return
  end
  
  def grab_unpaid_bills
    @bills = @cur_user.unpaid_bills  
  end
  
  def grab_unrec_bills
    @bills = @cur_user.unrec_bills
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
