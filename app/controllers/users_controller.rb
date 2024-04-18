class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def index
    all_users = User.where.not(id: logged_in_user.id)
    render json: all_users
  end

  def show
    user = User.find(params[:user_id])
    render json: user
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
