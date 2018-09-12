class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login_user!(username, password)
    @user = User.find_by_credentials(username, password)

    if @user
      session[:session_token] = @user.reset_session_token!
      redirect_to cats_url
    else
      render json: { cats: 'are cool' }
    end
  end
end
