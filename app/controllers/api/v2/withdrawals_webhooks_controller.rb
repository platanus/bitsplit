class Api::V2::WithdrawalsWebhooksController < Api::V2::BaseController
    # class Api::V2::WithdrawalsWebhookController < ApplicationController
    
    before_action :authenticate_user!, except: [:create]
  
    def create
        invoice = params[:reference]
        order = UserWithdrawal.find_by(invoice: invoice)
        order.update(completed: true)
        user = User.find_by(id: order.user_id)
        ledgerizer = LedgerizerService.new
        ledgerizer.withdrawal(user, order.amount)
        @updated_order = order
    end
  end 
