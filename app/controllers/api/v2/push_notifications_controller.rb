class Api::V2::PushNotificationsController < Api::V2::BaseController

  def create
    exists = NotificationToken.find_by(:token => params[:token], :user => current_user)
    if exists.nil?
      NotificationToken.create(:token => params[:token], :user => current_user)
      render json: { message: "push notification token saved" }, status: 200 and return
    else
      render json: { message: "token already exists" }, status: 409 and return
    end
  end

  private

  def request_params
    params.require(:token)
  end
end
