class Api::V2::TransfersController < Api::V2::BaseController
  
  def create
    receiver = User.find_by(email: params[:receiver_email])
    new_receiver = false
    if receiver.nil?
      new_receiver = true
      new_user_service = UnregisteredUserService.new(email: params[:receiver_email])
      receiver = new_user_service.create
    end
    render(json: { error: 'you can not transfer to yourself' }, status: 400) && return if receiver == current_user

    money_service = MoneyService.new(sender: current_user, receiver: receiver, amount: params[:amount], wallet_origin: params[:wallet_origin])
    success, message = money_service.payment

    if success
      reset_token = ResetPasswordService.new.create_reset_password_token(receiver)
      if !new_receiver
        NotificationsService.new(receiver).payment_notifications(current_user.email, params[:amount])
        UserMailer.with(user: receiver, sender: current_user, amount: params[:amount]).payment_email.deliver_now
      else
        UserMailer.with(user: receiver, sender: current_user, amount: params[:amount], token: reset_token).unregistered_email.deliver_now
      end
      @response = message
    else
      @error_message = message
      render('error')
    end
  end
end
