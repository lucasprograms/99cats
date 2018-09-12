class UsersController < ApplicationController
  before_action :redirect_to_cats_index_if_signed_in, only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(user_params)
    else
      redirect_to new_user_url @user
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def redirect_to_cats_index_if_signed_in
    redirect_to cats_url if current_user
  end
end
