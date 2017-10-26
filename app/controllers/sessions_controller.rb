class SessionsController < ApplicationController

  # Using OmniAuth
  def create
    auth = request.env['omniauth.auth']
    auth_without_extra = auth.except('extra')
    user = User.sign_in_from_omniauth(auth)
    if user
      log_in user
      redirect_to root_url
    else
      user = User.create_user(auth)
      # user.send_welcome_email
      flash[:info] = "Welcome! Check our email for further steps."
      redirect_to root_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
