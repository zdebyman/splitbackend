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
    payer = User.find_by!(username: expense_params[:payer]) 

    modified_splits_attrs = modify_split_amounts(expense_params[:split_type], expense_params[:splits_attributes], expense_params[:total_amount])
    resolved_splits_attrs = resolve_payee_names(modified_splits_attrs)
    modified_expense_params = expense_params.except(:payer, :splits_attributes).merge(splits_attributes: resolved_splits_attrs, payer_id: payer.id)

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
                                    :payer,
                                    :split_type,
                                    splits_attributes: [
                                      :id, 
                                      :payee, 
                                      :amount, 
                                      :_destroy])
  end

  def resolve_payee_names(splits)
    splits.map do |split|
      payee = User.find_by!(username: split[:payee])
      split[:payee_id] = payee.id
      split.except(:payee)
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Payee not found." }, status: :unprocessable_entity
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
