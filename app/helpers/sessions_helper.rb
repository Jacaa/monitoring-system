module SessionsHelper

  def log_in(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && (user.remember_token == cookies.signed[:remember_token])
        @current_user = user
      end
    end
  end

  def correct_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
  end
end
