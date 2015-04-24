json.extract! @bill, :id, :creditor_id, :debtor_id, :amount, :settled
json.settled_date @bill.settled_date.to_formatted_s