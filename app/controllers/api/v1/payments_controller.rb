class Api::V1::PaymentsController < ApplicationController

    def create
        _secrets = Rails.application.secrets
        @user = current_user
        @receiver_user = User.where(email: params[:receiver_email]).first
        bitcoins_amount = params[:payment_amount]
        if @receiver_user.nil? 
            @error_message = "no user found with given email" 
            render "error"
        end
        if @user.api_key.nil? || @receiver_user.api_key.nil?
            @error_message = "both users must have their buda api_keys" 
            render "error"
        end
        user_api_key = @user.decrypt(@user.api_key)
        user_api_secret = @user.decrypt(@user.api_secret)
        receiver_user_api_key = @receiver_user.decrypt(@receiver_user.api_key)
        receiver_user_api_secret = @receiver_user.decrypt(@receiver_user.api_secret)
        buda_receiver = BudaUserService.new(api_key: receiver_user_api_key, api_secret: receiver_user_api_secret)
        invoice = buda_receiver.generate_invoice(bitcoins_amount)
        if !invoice.has_key? "invoice"
            @error_message = invoice
            render "error"
        end
        
        invoice_body = JSON.parse(invoice.body)
        invoice_code = invoice_body["invoice"]["encoded_payment_request"]
        buda_payer = BudaUserService.new(api_key: user_api_key, api_secret: user_api_secret)
        invoice_payment = buda_payer.pay_invoice(bitcoins_amount, invoice_code, _secrets.buda_payment_simulation)
        return set_success_params(invoice_payment) if invoice_payment.has_key? "withdrawal"
        @error_message = invoice_payment 
        render "error"
        
    end


    def set_success_params(invoice_payment)
        @payment_amount = invoice_payment['withdrawal']['amount'] 
        @payment_state = invoice_payment['withdrawal']['state'] 
    end
end
