class NotificationsController < ApplicationController
  before_action :set_notification, except: :index

  def index
    skip_authorization

    @notifications = current_user.notifications.sent_or_read
  end

  def show
    authorize @notification

    @notification.mark_read! if @notification.sent?
  end

  def dismiss
    authorize @notification

    @notification.mark_dismissed!

    redirect_to notifications_path
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
