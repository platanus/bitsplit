class Api::V1::Splitwise::DebtsController < ApplicationController
  def show
    if current_user.authenticated_with_splitwise
      user_groups = generate_splitwise_service.current_user_groups
      user_friends = @splitwise_service.current_user_friends['friends']
      current_user = @splitwise_service.current_user_info['user']
      user_friends.push(current_user)
      @user_to_friends, @friends_to_user = helpers.generate_answer(user_groups, user_friends)
    else
      @error_message = "user has not synchronized splitwise"
      render 'error', status: 401
    end
  end

  def create
    response = generate_splitwise_service.payoff_debt(params[:amount], params[:currency_code], params[:group_id], params[:to_user_id])
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
