class FirebaseService < PowerTypes::Service.new
  # para llamarlo desde un controlador:
  # firebase = FirebaseService.new
  # firebase.buda_keys_update_notification(current_user)

  def send_notification(type, data)
    @firebase.push("notifications/#{@clean_email}", { type: type, data: data, seen: false })
  end

  def payment_notification(payment)
    # get payment data and send notification
    # you can edit the notification data here
    send_notification('payment', payment.as_json)
  end

  def save_token(token)
    hash = Hash(@firebase.get("tokens/#{@clean_email}").body)
    hash[token] = true
    @firebase.update('tokens', { @clean_email.to_sym => hash })
  end

  def delete_token(token)
    hash = Hash(@firebase.get("tokens/#{@clean_email}").body)
    hash.delete(token)
    @firebase.update('tokens', { @clean_email.to_sym => hash })
  end

  def update_notification_status(token)
    @firebase.update("notifications/#{@clean_email}/#{token}", { seen: true })
  end

  private

  def initialize(user)
    @user = user
    @clean_email = @user.email.sub '.', ','
    firebase_url = 'https://platanus-bitsplit.firebaseio.com/'
    firebase_credentials = {
      "type": 'service_account',
      "project_id": 'platanus-bitsplit',
      "private_key_id": ENV.fetch('FIREBASE_PRIVATE_KEY_ID'),
      "private_key": ENV.fetch('FIREBASE_PRIVATE_KEY'),
      "client_email": 'firebase-adminsdk-qj7zf@platanus-bitsplit.iam.gserviceaccount.com', "client_id": '105168040932761626714',
      "auth_uri": 'https://accounts.google.com/o/oauth2/auth',
      "token_uri": 'https://oauth2.googleapis.com/token',
      "auth_provider_x509_cert_url": 'https://www.googleapis.com/oauth2/v1/certs', "client_x509_cert_url": 'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qj7zf%40platanus-bitsplit.iam.gserviceaccount.com'
    }
    @firebase = Firebase::Client.new(firebase_url, firebase_credentials.to_json)
  end
end
