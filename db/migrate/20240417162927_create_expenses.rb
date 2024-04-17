class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :description, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.date :date, null: false
      t.integer :payer_id, null: false

      t.timestamps
    end
    add_index :expenses, :payer_id
  end
end
