class AddSplitTypeToExpense < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :split_type, :string, null: false
  end
end
