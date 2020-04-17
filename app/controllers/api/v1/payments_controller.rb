class Api::V1::PaymentsController < ApplicationController

    def create

        #TODO: setear esta variable para simular o no
        payment_simulation=true
        @user = current_user
        @receiver_user=User.where(email: params[:receiver_email]).first
        bitcoins_amount=params[:payment_amount]
        if @receiver_user == nil
            @error_message = "no user found with given email" 
            render "error"
        end
        if @user.api_key == nil || @receiver_user.api_key == nil
            @error_message = "both users must have their buda api_keys" 
            render "error"
        end
        user_api_key=@user.decrypt(@user.api_key)
        user_api_secret=@user.decrypt(@user.api_secret)
        receiver_user_api_key=@receiver_user.decrypt(@receiver_user.api_key)
        receiver_user_api_secret=@receiver_user.decrypt(@receiver_user.api_secret)
        invoice=InvoicesController.create_new_invoice(bitcoins_amount, receiver_user_api_key, receiver_user_api_secret)
        if !invoice.has_key? "invoice"
            @error_message = invoice
            render "error"
        end
        
        invoice_body=JSON.parse(invoice.body)
        invoice_code=invoice_body["invoice"]["encoded_payment_request"]
        invoice_payment = InvoicesController.pay_new_invoice(bitcoins_amount, invoice_code, payment_simulation, user_api_key, user_api_secret)
        return set_success_params(invoice_payment) if invoice_payment.has_key? "withdrawal"
        @error_message = invoice_payment 
        render "error"
        
    end

    def set_success_params(invoice_payment)
        @payment_amount = invoice_payment['withdrawal']['amount'] 
        @payment_state = invoice_payment['withdrawal']['state'] 
    end

    private

    def payment_params
        params.require(:receiver_email, :payment_amount)
    end
end

