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
      if @bill.update_attribute(:amount, amount)
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
      if bill.settle == true
        render :json => {message: 'This bill has already been settled'}, status: :bad_request and return
      end
      if @bill.update_attribute(:amount, amount)
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
    @bill.settled = true
    @bill.settled_date = Time.now
    if @bill.save
      render :show, status: :ok and return
    else
      render :json => {message: 'Failed to settle the bill'}, status: :bad_request and return
    end
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
