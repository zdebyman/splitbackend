class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show]

  def index
    @expenses = Expense.where(payer_id: @user.id)
    render json: @expenses
  end

  def show
    render json: @expense
  end

  def new
    @expense = Expense.new
    @expense.splits.build
  end

  def create
    payer = User.find_by!(id: expense_params[:payer_id])

    modified_splits_attrs = modify_split_amounts(expense_params[:split_type], expense_params[:splits_attributes], expense_params[:total_amount])
    modified_expense_params = expense_params.merge(splits_attributes: modified_splits_attrs)
    @expense = payer.expenses.build(modified_expense_params)

    if @expense.save
      render json: @expense, status: :created, location: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, 
                                    :total_amount, 
                                    :date, 
                                    :payer_id,
                                    :split_type,
                                    splits_attributes: [
                                      :id, 
                                      :payee_id, 
                                      :amount, 
                                      :_destroy])
  end

  def modify_split_amounts(split_type, splits, total_amount)
    splits.map do |split|
      if split_type == "amount"
        split[:amount] = split[:amount]
      else
        split[:amount] = (split[:amount].to_f / 100) * total_amount.to_f
      end
      split
    end
  end

end
