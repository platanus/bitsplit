class Api::V1::PaymentsController < Api::V1::BaseController
    # class Api::V1::PaymentsController < ApplicationController

    def create
        #TODO: setear esta variable para simular o no
        payment_simulation = true
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
        invoice_id = invoice_body["invoice"]["id"]
        new_payment = Payment.create!(:sender => @user, 
                        :receiver => @receiver_user, 
                        :amount => bitcoins_amount,  
                        :completed => true, 
                        :invoice_id => invoice_id)
        invoice_code = invoice_body["invoice"]["encoded_payment_request"]
        buda_payer = BudaUserService.new(api_key: user_api_key, api_secret: user_api_secret)
        invoice_payment = buda_payer.pay_invoice(bitcoins_amount, invoice_code, payment_simulation)
        if invoice_payment.has_key? "withdrawal"

            # Use firebase service to send payment notification
            firebase = FirebaseService.new
            firebase.payment_notification(@receiver_user, new_payment)

            return respond_with new_payment 
        else
            @error_message = invoice_payment 
            Payment.update(:completed => false)
            render "error"
        end
    end


    def show
        payments_record = current_user.payments_record
        respond_with payments_record
    end

    private

    def payment_params
        params.require(:payment_amount)
    end
end
