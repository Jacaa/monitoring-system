class SessionsController < ApplicationController

  # Using OmniAuth
  def create
    auth = request.env['omniauth.auth']
    user = User.sign_in_from_omniauth(auth)
    if user
      log_in user
      redirect_to root_url
    else
      user = User.create_user(auth)
      log_in user
      user.send_welcome_email
      flash[:info] = "Welcome! Check your email for further steps."
      redirect_to root_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
