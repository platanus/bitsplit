class PushNotificationService < PowerTypes::Service.new
  # para llamarlo desde un controlador:
  # PushNotificationService.new(user).send_notifications

  def send_notification(type, messages)
    # MAX 100 messages at a time
    handler = @push_client.send_messages(messages)
    # Array of all errors returned from the API
    # puts handler.errors
    #@push_client.verify_deliveries(handler.receipt_ids)
  end

  def payment_message(token)
    message = {
      to: "ExponentPushToken[#{token}]",
      sound: "default",
      body: "Has recibido un nuevo pago!"
    }
  end

  def payment_notification
    messages = []
    @tokens.each do |token|
      messages.push(payment_message(token.token))
    end
    send_notification("payment", messages)
  end

  private

  def initialize(user)
    @user = user
    @tokens = NotificationToken.where(user: @user)
    @push_client =  Exponent::Push::Client.new
  end
end
