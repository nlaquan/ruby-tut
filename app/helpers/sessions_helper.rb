module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      current_user_by_session user_id
    elsif (user_id = cookies.signed[:user_id])
      current_user_by_cookies user_id
    end
  end

  def current_user_by_session id
    @current_user ||= User.find_by id: id
  end

  def current_user_by_cookies id
    user = User.find_by id: id
    return unless user && user.authenticated?(cookies[:remember_token])
    log_in user
    @current_user = user
  end

  def logged_in?
    current_user
  end

  def remember user
    @current_user = user
    @current_user.remember
    cookies_permanent = cookies.permanent
    cookies_permanent.signed[:user_id] = @current_user.id
    cookies_permanent[:remember_token] = @cureent_user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end
end
