class PushNotificationService < PowerTypes::Service.new

  def send_notification(type, messages)
    @push_client.send_messages(messages)
  end

  def payment_message(token)
    message = {
      to: token,
      sound: "default",
      body: "Has recibido un nuevo pago!"
    }
  end

  def payment_notification
    return unless @user.notification_tokens.any?
    
    messages = []
    @user.notification_tokens.each do |token|
      messages.push(payment_message(token.token))
    end
    send_notification("payment", messages)
  end

  private

  def initialize(user)
    @user = user
    @push_client =  Exponent::Push::Client.new
  end
end
