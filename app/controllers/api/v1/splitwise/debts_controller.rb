class Api::V1::Splitwise::DebtsController < ApplicationController
  def show
    return unless current_user.authenticated_with_splitwise

    user_groups = splitwise_service.current_user_groups
    user_friends = splitwise_service.current_user_friends['friends']
    current_user = splitwise_service.current_user_info['user']
    user_friends.push(current_user)
    @user_to_friends, @friends_to_user = helpers.generate_answer(user_groups, user_friends)
  end

  def create
    #respond_with({ error: @error_message }, status: :unprocessable_entity)

    success, @error_message, _new_payment = payment_service.create_payment(params[:payment_amount])
    render('error') && return unless success
    response = splitwise_service.payoff_debt(params)
    if response.code == '200'
      head(:created)
    else
      head(:unauthorized)
    end
  end

  private


  def create_params
    params.permit(:group_id, :to_user_id, :payment_amount)
  end

  def splitwise_service
    @splitwise_service ||= SplitwiseService.new(user: current_user)
  end

  def payment_service
    @payment_service ||= PaymentsService.new(sender: current_user, receiver: User.find_by(splitwise_user_id: params[:to_user_id]))
  end
end
