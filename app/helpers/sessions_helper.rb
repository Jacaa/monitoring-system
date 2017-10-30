module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && (user.remember_token == cookies.signed[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
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
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
  end
end
