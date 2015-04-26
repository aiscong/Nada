json.unrec_bills @bills do |bill|
  json.id bill.id
  json.creditor_id bill.creditor_id
  json.debtor_id bill.debtor_id
  json.amount bill.amount
  json.settled bill.settled
  if bill.settled_date != nil 
    json.settled_date bill.settled_date.to_formatted_s
  else
    json.settled_date bill.settled_date
  end
end