module SessionsHelper
  def current_session
    Current.session
  end

  def current_user
    current_session&.user
  end

  def signed_in?
    current_user.present?
  end
end
