class SessionsController < ApplicationController
  before_action :redirect_to_cats_index_if_signed_in, only: [:new]

  def new
  end

  def create
    login_user!(session_params[:username], session_params[:password])
  end

  def destroy
    current_user && current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end

  def redirect_to_cats_index_if_signed_in
    redirect_to cats_url if current_user
  end
end
