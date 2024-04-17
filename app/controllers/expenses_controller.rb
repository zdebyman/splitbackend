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
    @expense = @user.expenses.build(expense_params.merge(payer_id: payer.id))

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
                                    splits_attributes: [:id, :payee_id, :amount, :_destroy])
  end
end
