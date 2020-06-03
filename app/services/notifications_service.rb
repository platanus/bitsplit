class NotificationsService < PowerTypes::Service.new

  def payment_data(sender, amount)
    data = {sender: sender, amount: amount, created_at: Time.now.to_i}
  end

  def payment_notifications(sender, amount)
    data = payment_data(sender, amount)
    @firebase.payment_notification(data)
    @push_notifications.payment_notification
    return
  end

  private

  def initialize(user)
    @firebase = FirebaseService.new(user)
    @push_notifications = PushNotificationService.new(user)
  end
end
