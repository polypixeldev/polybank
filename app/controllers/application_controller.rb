class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  after_action :verify_authorized

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_action

  def authorize_with_share(record, share_sid)
    if share_sid.present?
      share = Share.find_signed(share_sid)

      if share.target == record
        authorize share
      else
        raise Pundit::NotAuthorizedError
      end
    else
      authorize record
    end
  end

  private

  def unauthorized_action
    flash[:error] = "You aren't authorized for that!"
    redirect_back_or_to root_path
  end
end
