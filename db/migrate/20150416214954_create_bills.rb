class CreateBills < ActiveRecord::Migration
  def change
    drop_table :bills
    create_table :bills do |t|
      t.integer :creditor_id
      t.integer :debtor_id

      t.timestamps null: false
    end
    
    add_index :bills, :creditor_id
    add_index :bills, :debtor_id
    add_index, [:creditor_id, :debtor_id, :created_at], unique: true
  end
end
