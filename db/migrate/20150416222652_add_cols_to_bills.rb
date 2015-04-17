class AddColsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :amount, :decimal, :default => 0.0
    add_column :bills, :settled, :boolean, :default => false
    add_column :bills, :settled_date, :datetime, :default => nil
  end
end
