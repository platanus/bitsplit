class NotificationsService < PowerTypes::Service.new

  def payment_notifications(payment)
    @firebase.payment_notification(payment)
    @push_notifications.payment_notification
  end

  private

  def initialize(user)
    @firebase = FirebaseService.new(user)
    @push_notifications = PushNotificationService.new(user)
  end
end
