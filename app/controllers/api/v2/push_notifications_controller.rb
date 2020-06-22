class Api::V2::PushNotificationsController < Api::V2::BaseController

  def create
    token = NotificationToken.find_by(:token => params[:token])
    auth_token = Tiddle::TokenIssuer.build.find_token(current_user, request.headers['X-User-Token'])
    if token.nil?
      NotificationToken.create(:token => params[:token], :user => current_user, :authentication_token => auth_token)
      render json: { message: "push notification token saved" }, status: 200 and return
    elsif token.user != current_user
      token.update({:user => current_user,
        :authentication_token => auth_token})
      render json: { message: "push notification token updated" }, status: 200 and return
    end
    render json: { message: "token already exists" }, status: 409 and return
  end

  private

  def request_params
    params.require(:token)
  end
end
