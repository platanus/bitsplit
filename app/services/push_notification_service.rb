class PushNotificationService < PowerTypes::Service.new

  def send_notification(type, messages)
    @push_client.send_messages(messages)
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
