class AddColToUser < ActiveRecord::Migration
  def change
    add_column :users, :reg_id, :text
  end
end
