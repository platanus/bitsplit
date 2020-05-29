class Api::V1::Splitwise::DebtsController < ApplicationController
  def show
    return unless current_user.authenticated_with_splitwise

    user_groups = generate_splitwise_service.current_user_groups
    user_friends = @splitwise_service.current_user_friends['friends']
    current_user = @splitwise_service.current_user_info['user']
    user_friends.push(current_user)
    @user_to_friends, @friends_to_user = helpers.generate_answer(user_groups, user_friends)
  end

  def create
    # respond_with({ error: @error_message }, status: :unprocessable_entity)
    success, @error_message, _new_payment = generate_payment_service.create_payment(payment_params)
    head(:unprocessable_entity) && return unless success

    response = generate_splitwise_service.payoff_debt(create_params)
    if response.code == '200'
      head(:created)
    else
      head(:unauthorized)
    end
  end

  private

  def payment_params
    params.require(:debt).permit(:group_id, :to_user_id, :payment_amount)
  end

  def create_params
    params.permit(:group_id, :to_user_id, :payment_amount)
  end

  def generate_splitwise_service
    @splitwise_service ||= SplitwiseService.new(user: current_user)
  end

  def generate_payment_service
    @payments_service = PaymentsService.new(sender: current_user, receiver: User.find_by(splitwise_user_id: params[:to_user_id]))
  end
end
