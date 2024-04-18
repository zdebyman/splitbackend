class BalancesController < ApplicationController
  def index
    # Initialize balances for all users except @user and pre-load needed data
    balances = User.where.not(id: @user.id).each_with_object({}) { |user, h| h[user.username] = 0 }
  
    # Preload expenses and associated splits involving @user
    involved_expenses = Expense.includes(splits: :payee)
                               .where(payer_id: @user.id)
                               .or(Expense.includes(splits: :payee)
                                          .where(splits: { payee_id: @user.id }))
  
    involved_expenses.each do |expense|
      if expense.payer_id == @user.id
        # My Expense: I am the payer
        expense.splits.each do |split|
          next if split.payee_id == @user.id
          balances[split.payee.username] += split.amount if balances.key?(split.payee.username)
        end
      else
        # Not my expense, but I am involved as a payee
        expense.splits.each do |split|
          if split.payee_id == @user.id
            balances[expense.payer.username] -= split.amount if balances.key?(expense.payer.username)
          end
        end
      end
    end
  
    # Transform the balances hash into an array of hashes
    result = balances.map do |username, balance|
      { username: username, balance: balance.to_s }
    end

    render json: result
  end
end

