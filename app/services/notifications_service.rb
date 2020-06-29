class NotificationsService < PowerTypes::Service.new

  def payment_data(sender, amount)
    data = {sender: sender, amount: amount, created_at: Time.now}
  end

  def payment_notifications(sender, amount)
    data = payment_data(sender, amount)
    @firebase.payment_notification(data)
    @push_notifications.payment_notification
    UserMailer.with(user: @current_user, sender: sender, amount: amount).payment_email.deliver_now
  end

  private

  def initialize(user)
    @current_user = user
    @firebase = FirebaseService.new(user)
    @push_notifications = PushNotificationService.new(user)
  end
end
