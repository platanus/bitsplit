class FirebaseService < PowerTypes::Service.new
    # para llamarlo desde un controlador:
    # firebase = FirebaseService.new
    # firebase.buda_keys_update_notification(current_user)

    def send_notification(type, data)
        response = @firebase.push("notifications/#{@clean_email}", {:type => type, :data => data, :seen => false})
    end

    def payment_notification(payment)
        #get payment data and send notification
        #you can edit the notification data here
        send_notification("payment", payment.as_json)
    end
    
    def save_token
        response = @firebase.update("tokens", { @clean_email.to_sym => @user.authentication_token })
    end

    def update_notification_status(token)
        response = @firebase.update("notifications/#{@clean_email}/#{token}", {:seen => true})
    end
  
    private
    def initialize(user)
        @user = user
        @clean_email = @user.email.sub '.', ','
        firebase_url = 'https://platanus-bitsplit.firebaseio.com/'
        private_key_json_string = Rails.application.secrets.firebase_credentials
        @firebase = Firebase::Client.new(firebase_url, private_key_json_string.to_s)
    end
  
end