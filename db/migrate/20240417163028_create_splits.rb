class CreateSplits < ActiveRecord::Migration[7.1]
  def change
    create_table :splits do |t|
      t.integer :expense_id, null: false
      t.integer :payee_id, null: false
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
    add_index :splits, :expense_id
    add_index :splits, :payee_id
  end
end
