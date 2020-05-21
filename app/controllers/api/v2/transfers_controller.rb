class Api::V2::TransfersController < Api::V2::BaseController

  def create
    @receiver = User.find_by(email: params[:receiver_email])
    if @receiver.nil?
      render json: { error: 'invalid receiver email' }, status: 400 and return
    end
    if @receiver == current_user
      render json: { error: 'you can not transfer to yourself' }, status: 400 and return
    end
    success, @error_message = LedgerizerService.new.transfer(
      current_user, @receiver, params[:amount])
    if success
      head :ok
    else
      render json: { error: @error_message}, status: 400
    end
  end

  private

  def transfer_params
    params.require(:receiver_email, :amount)
  end
end
