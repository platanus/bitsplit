class Api::V1::PaymentsController < Api::V1::BaseController
    # class Api::V1::PaymentsController < ApplicationController
 
    def create
        sender = current_user
        receiver = User.where(email: params[:receiver_email]).first
        if receiver.nil? 
            @error_message = "no user found with given email" 
            render "error" and return
        end
        if sender.api_key.nil? || receiver.api_key.nil?
            @error_message = "both users must have their buda api_keys" 
            render "error" and return
        end
        sender_api_key, sender_api_secret = sender.get_buda_keys()
        receiver_api_key, receiver_api_secret = receiver.get_buda_keys()
        bitcoins_amount = params[:payment_amount]
        invoice = receiver_invoice(receiver_api_key, receiver_api_secret, bitcoins_amount)
        if !invoice.has_key? "invoice"
            @error_message = invoice
            render "error" and return 
        end
        invoice_body = JSON.parse(invoice.body)
        invoice_id = invoice_body["invoice"]["id"]
        invoice_code = invoice_body["invoice"]["encoded_payment_request"]
        new_payment = create_new_payment(sender, receiver, bitcoins_amount, invoice_id)
        invoice_payment = sender_payment(sender_api_key, sender_api_secret, bitcoins_amount, invoice_code)
        if !invoice_payment.has_key? "withdrawal"
          @error_message = invoice_payment 
          Payment.update(:completed => false)
          render "error" and return
        end
      
        # Use firebase service to send payment notification
        firebase = FirebaseService.new(receiver)
        firebase.payment_notification(new_payment)
      
        return respond_with new_payment
    end

    def show
        payments_record = current_user.payments_record
        respond_with payments_record
    end


    private

    def payment_params
        params.require(:payment_amount)
    end

    def create_new_payment(sender, receiver, bitcoins_amount, invoice_id)
        Payment.create!(:sender => sender, 
                        :receiver => receiver, 
                        :amount => bitcoins_amount,  
                        :completed => true, 
                        :invoice_id => invoice_id)    
    end

    def receiver_invoice(api_key, api_secret, bitcoins_amount)
        buda_receiver = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        invoice = buda_receiver.generate_invoice(bitcoins_amount)
    end

    def sender_payment(api_key, api_secret, bitcoins_amount, invoice_code)
        _secrets = Rails.application.secrets
        buda_payer = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        invoice_payment = buda_payer.pay_invoice(bitcoins_amount, invoice_code, _secrets.buda_payment_simulation)
    end

end

   