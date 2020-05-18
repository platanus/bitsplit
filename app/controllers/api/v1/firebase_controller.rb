class Api::V1::FirebaseController < ApplicationController
  def update
    firebase = FirebaseService.new(current_user)
    firebase.update_notification_status(params[:notification_token])
    head(:ok)
  end
end
