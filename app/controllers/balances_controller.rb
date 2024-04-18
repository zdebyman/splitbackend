class BalancesController < ApplicationController

  def index
    puts "\n\n\n Hello from BalancesController#index"
    puts "@user = #{@user.inspect}"

    balances = {}
    Split.all.where(payee_id: @user.id).each do |split|
      puts "split = #{split.inspect}"

      expense = Expense.find(split.expense_id)
      expense.splits.each do |curr_split|
        if curr_split.payee_id == @user.id
          next # skip self
        end

        amount = expense.payer_id == @user.id ? curr_split.amount : -curr_split.amount

        if !balances.include?(expense.payer_id)
          payer = User.find(expense.payer_id)

          balances[expense.payer_id] = {
            "amount" => 0,
            "username" => payer.username,
            "id" => payer.id
          }
        end

        balances[expense.payer_id]["amount"] += amount
      end
    end

    puts "balances = #{balances.inspect}"
    render json: balances
  end

end
