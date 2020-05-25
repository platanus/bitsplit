class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    request = OpenNodeService.new(withdrawals_api_key: ENV.fetch('OPENNODE_WITHDRAWALS_KEY'))
    @response = request.send_withdrawal_request(params[:invoice])
  end
end
