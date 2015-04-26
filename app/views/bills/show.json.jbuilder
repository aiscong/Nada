json.extract! @bill, :id, :creditor_id, :debtor_id, :amount, :settled
if @bill.settled_date != nil 
  json.settled_date @bill.settled_date.to_formatted_s
else
  json.settled_date @bill.settled_date
end