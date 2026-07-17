module SessionsHelper
  def current_session
    Current.session
  end

  def current_user
    current_session.user
  end
end
