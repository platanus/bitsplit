class Api::V1::PaymentsController < Api::V1::BaseController
  # class Api::V1::PaymentsController < ApplicationController

  def create
    receiver = User.find_by(email: params[:receiver_email])
    payments_service = PaymentsService.new(sender: current_user, receiver: receiver)
    success, @error_message, new_payment = payments_service.create_payment(params[:payment_amount])

    render('error') && return unless success

    # Use firebase service to send payment notification deprecated
    # FirebaseService.new(receiver).payment_notification(new_payment)

    respond_with new_payment
  end

  def show
    payments_record = current_user.payments_record
    respond_with payments_record
  end
end
