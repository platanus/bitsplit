class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    request = OpenNodeService.new
    @response = request.send_withdrawal_request(params[:invoice])
  end
end
