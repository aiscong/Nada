class BillsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @creditor_user = User.find_by(id: params[:creditor_id])
    @debtor_user = User.find_by(id: params[:debtor_id])
    @bill = @debtor_user.unpaid_bills.build(creditor_id: @creditor_user.id, amount: params[:amount])
    @bill.save
    render :show
  end
  
  def show
    @bill = Bill.find(params[:id])
  end
  
  def update
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
end
