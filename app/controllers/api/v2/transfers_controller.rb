class Api::V2::TransfersController < Api::V2::BaseController
  def create
    receiver = User.find_by(email: params[:receiver_email])
    render(json: { error: 'invalid receiver email' }, status: 400) && return if receiver.nil?
    render(json: { error: 'you can not transfer to yourself' }, status: 400) && return if receiver == current_user

    money_service = MoneyService.new(sender: current_user, receiver: receiver, amount: params[:amount], wallet_origin: params[:wallet_origin])
    success, error_message = money_service.payment

    if success
      head :ok
    else
      render json: { error: error_message }, status: 400
    end
  end
end
