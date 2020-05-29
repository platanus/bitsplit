class Api::V2::ChargesController < Api::V2::BaseController
  # class Api::V2::ChargesController < ApplicationController

  def create
    # TODO: create model to check payment of invoices and only admit once
    # IMPORTANT as currently people can recharge infinitely
    open_node_service = OpenNodeService.new
    @response = open_node_service.send_charge_request(params[:amount], params[:currency])
  end
end
