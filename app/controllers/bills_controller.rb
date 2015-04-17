class BillsController < ApplicationController
  def create
    
  end
  
  def destroy
  end
  
  private
    def bill_params
       params.require(:bill).permit(:creditor_id, :debtor_id, :amount)
    end
end
