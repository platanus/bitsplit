class Api::V1::PaymentsController < Api::V1::BaseController
    # class Api::V1::PaymentsController < ApplicationController

    def create
        _secrets = Rails.application.secrets
        sender = current_user
        receiver = User.where(email: params[:receiver_email]).first
        if receiver.nil? 
            @error_message = "no user found with given email" 
            render "error"
        end
        if sender.api_key.nil? || receiver.api_key.nil?
            @error_message = "both users must have their buda api_keys" 
            render "error"
        end
        sender_api_key, sender_api_secret = sender.get_buda_keys()
        receiver_api_key, receiver_api_secret = receiver.get_buda_keys()
        bitcoins_amount = params[:payment_amount]
        buda_receiver = BudaUserService.new(api_key: receiver_api_key, api_secret: receiver_api_secret)
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
        buda_payer = BudaUserService.new(api_key: sender_api_key, api_secret: sender_api_secret)
        invoice_payment = buda_payer.pay_invoice(bitcoins_amount, invoice_code, _secrets.buda_payment_simulation)
        if !invoice_payment.has_key? "withdrawal"
          @error_message = invoice_payment 
          Payment.update(:completed => false)
          render "error"
        return respond_with new_payment
    end

    def show
        payments_record = current_user.payments_record
        respond_with payments_record
    end

    private

    def payment_params
        params.require(:payment_amount)

   