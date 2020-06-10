class Api::V2::DepositwebhooksController < Api::V2::BaseController
    # class Api::V2::DepositwebhooksController < ApplicationController
  
    def create
        order_id = params[:order_id]
        order = UserDeposit.find_by(id: order_id)
        order.update(completed: true)
        user = User.find_by(id: order.user_id)
        ledgerizer = LedgerizerService.new
        ledgerizer.deposit(user, order.amount)
        @updated_order = order
    end
  end 