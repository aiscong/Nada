class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.decimal :total
      t.string :name
      t.text :note

      t.timestamps null: false
    end
  end
end
