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
    response = generate_splitwise_service.payoff_debt(params[:amount_clp], params[:group_id], params[:to_user_id])
    if response.code != '200'
      head(:unauthorized)
    end
    @splitwise_response = response
  end

  private

  def generate_splitwise_service
    @splitwise_service ||= SplitwiseService.new(user: current_user)
  end

  def generate_payment_service
    @payments_service = PaymentsService.new(sender: current_user, receiver: User.find_by(splitwise_user_id: params[:to_user_id]))
  end
end
