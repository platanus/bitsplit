class FirebaseService < PowerTypes::Service.new
    # para llamarlo desde un controlador:
    # firebase = FirebaseService.new
    # firebase.buda_keys_update_notification(current_user)

    def payment_notification(user, payment)
        #get payment data and send notification
        send_notification(user, "payment", payment.as_json)
    end

    def login_notification(user)
        #other notification wrapper
        send_notification(user, "login", "user logged in")
    end

    def buda_keys_update_notification(user)
        #get payment data and send notification
        send_notification(user, "update", "user updated buda api keys")
    end
  
    def send_notification(user, type, data)
        key = user.email.split("@").first
        response = @firebase.push("notifications/#{key}", {:type => type, :data => data, :seen => false})
    end
  
    def save_token(user)
        key = user.email.split("@").first
        response = @firebase.update("tokens", { key.to_sym => user.authentication_token })
    end
  
    private
    def initialize
        firebase_url = 'https://platanus-bitsplit.firebaseio.com/'
        private_key_json_string = Rails.application.secrets.firebase_credentials
        @firebase = Firebase::Client.new(firebase_url, private_key_json_string)
    end
  
end