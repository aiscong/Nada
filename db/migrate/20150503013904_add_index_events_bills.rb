class AddIndexEventsBills < ActiveRecord::Migration
  def change
    add_reference :bills, :event, index: true, foreign_key: true
  end
end
