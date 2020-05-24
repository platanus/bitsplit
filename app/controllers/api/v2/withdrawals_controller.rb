class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    # TODO: create model to check payment of invoices and only admit once
    # IMPORTANT as currently people can recharge infinitely
    request = OpenNodeService.new
    @response = request.send_withdrawal_request(params[:invoice])
  end
end
