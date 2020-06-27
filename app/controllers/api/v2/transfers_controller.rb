class Api::V2::TransfersController < Api::V2::BaseController
  
  def create
    receiver = User.find_by(email: params[:receiver_email])
    if receiver.nil?
      new_user_service = UnregisteredUserService.new(email: params[:receiver_email])
      receiver = new_user_service.create
    end
    render(json: { error: 'you can not transfer to yourself' }, status: 400) && return if receiver == current_user

    money_service = MoneyService.new(sender: current_user, receiver: receiver, amount: params[:amount], wallet_origin: params[:wallet_origin])
    success, message = money_service.payment

    if success
      NotificationsService.new(receiver).payment_notifications(current_user.email, params[:amount])
      @response = message
    else
      @error_message = message
      render('error')
    end
  end

end
