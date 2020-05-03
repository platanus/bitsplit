class Api::V1::FirebaseController < ApplicationController

    acts_as_token_authentication_handler_for User

    def update
        firebase = FirebaseService.new(current_user)
        firebase.update_notification_status(params[:notification_token])
        head(:ok)
    end

    private
  
  end