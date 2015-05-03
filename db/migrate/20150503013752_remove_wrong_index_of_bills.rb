class RemoveWrongIndexOfBills < ActiveRecord::Migration
  def change
    remove_reference :bills, :events, index: true
    remove_foreign_key :bills, :events
  end
end
