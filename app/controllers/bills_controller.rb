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
  
  
end
