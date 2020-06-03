class Api::V2::TransactionsController < ApplicationController
  def show
    if current_user.splitwise_user_id
      splitwise_service ||= SplitwiseService.new(user: current_user)
      user_friends = splitwise_service.current_user_friends['friends']
      current_user_info = splitwise_service.current_user_info['user']
      user_friends.push(current_user_info)
    end
    @transactions_list = helpers.generate_answer(user_friends)
  end
end
