class Api::V2::ChargesController < Api::V2::BaseController
  # class Api::V2::ChargesController < ApplicationController

  def create
    new_user_deposit = UserDeposit.create!(user_id: current_user.id,
                                           amount: params[:amount], 
                                           completed: false)
    open_node_service = OpenNodeService.new
    response = open_node_service.send_charge_request(params[:amount], params[:currency], new_user_deposit.id)
    satoshis_amount = JSON.parse(response.body)['data']['amount'].to_f
    btc_amount = (satoshis_amount/ 100000000).to_f
    new_user_deposit.update(amount: btc_amount)
    @response = response
  end
end
