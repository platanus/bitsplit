class Api::V1::PaymentsController < ApplicationController

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
        receiver_api_key, receiver_api_secret= receiver.get_buda_keys()
        bitcoins_amount = params[:payment_amount]
        buda_receiver = BudaUserService.new(api_key: receiver_api_key, api_secret: receiver_api_secret)
        invoice = buda_receiver.generate_invoice(bitcoins_amount)
        if !invoice.has_key? "invoice"
            @error_message = invoice
            render "error"
        end
        invoice_body = JSON.parse(invoice.body)
        invoice_id = invoice_body["invoice"]["id"]
        Payment.create!(:sender => @user, 
                        :receiver => @receiver_user, 
                        :amount => bitcoins_amount,  
                        :state => 0, 
                        :invoice_id => invoice_id)
        invoice_code = invoice_body["invoice"]["encoded_payment_request"]
        buda_payer = BudaUserService.new(api_key: user_api_key, api_secret: user_api_secret)
        invoice_payment = buda_payer.pay_invoice(bitcoins_amount, invoice_code, payment_simulation)
        if !invoice_payment.has_key? "withdrawal"
            @error_message = invoice_payment 
            Payment.update(:state => 1)
            render "error"
        end
        return set_success_params(invoice_payment) 
    end

    def show
        sent_payments = current_user.sent_payments
        received_payments = current_user.received_payments
        @sent_payments_format = Array.new
        sent_payments.each do |payment|
            receiver_email = User.where(id: payment["receiver_id"]).first.email
            sent_payment_details = {id: payment["id"], 
                            receiver_email: receiver_email,
                            amount: payment["amount"],
                            state: payment["state"],
                            invoice_id: payment["invoice_id"],
                            created_at: payment["created_at"]}
            @sent_payments_format.push sent_payment_details
        end
        @received_payments_format = Array.new
        received_payments.each do |payment|
            sender_email = User.where(id: payment["sender_id"]).first.email
            rec_payment_details = {id: payment["id"], 
                            sender_email: sender_email,
                            amount: payment["amount"],
                            state: payment["state"],
                            invoice_id: payment["invoice_id"],
                            created_at: payment["created_at"]}
            @received_payments_format.push rec_payment_details
        end
    end

    def set_success_params(invoice_payment)
        @payment_amount = invoice_payment['withdrawal']['amount'] 
        @payment_state = invoice_payment['withdrawal']['state'] 
    end

    private
    
    def payment_params
        params.require(:payment_amount)
    end
end
