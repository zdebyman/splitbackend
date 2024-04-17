class SplitsController < ApplicationController
  before_action :set_expense

  def index
    @splits = @expense.splits
    render json: @splits
  end

  def create
    @split = @expense.splits.build(split_params)

    if @split.save
      render json: @split, status: :created, location: expense_split_url(@expense, @split)
    else
      render json: @split.errors, status: :unprocessable_entity
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:expense_id])
  end

  def split_params
    params.require(:split).permit(:payee_id, :amount)
  end
end
