class Api::V2::BudaPaysController < ApplicationController
    
    def create
        #amount = UserDeposit.find_by(id: params[:order_id]).amount
        api_key, api_secret = current_user.buda_keys
        buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
        payment = buda_service.pay_invoice(params[:amount], params[:invoice], simulate)
        #return nil unless check_buda_invoice_payment(payment)
        @answer = "hola"
    end

    private

    def buda_pays_params
      params.require(:invoice, :amount)
    end
end


  