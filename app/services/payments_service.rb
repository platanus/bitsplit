class PaymentsService < PowerTypes::Service.new(:sender, :receiver)

    @error_message = "error"

    def create_payment(params)
        # returns success, error, invoice
        return false, @error_message, nil if !check_users(@sender, @receiver)

        sender_api_key, sender_api_secret = @sender.get_buda_keys()
        receiver_api_key, receiver_api_secret = @receiver.get_buda_keys()
        invoice = receiver_invoice(receiver_api_key, receiver_api_secret, params[:payment_amount])

        return false, @error_message, nil if !check_invoice(invoice)

        invoice_id, invoice_code = invoice_id_and_code(invoice)
        new_payment = create_new_payment(@sender, @receiver, params[:payment_amount], invoice_id)
        invoice_payment = sender_payment(sender_api_key, sender_api_secret, params[:payment_amount], invoice_code)

        return false, @error_message, nil if !check_invoice_payment(invoice_payment)

        return true, @error_message, new_payment
    end

    private
    def check_users(sender, receiver)
        if receiver.nil? 
            @error_message = "no user found with given email" 
            return false
        end
        if sender.api_key.nil? || receiver.api_key.nil?
            @error_message = "both users must have their buda api_keys" 
            return false
        end
        return true
    end

    def check_invoice(invoice)
        if !invoice.has_key? "invoice"
            @error_message = invoice
            return false
        else
            return true
        end
    end

    def check_invoice_payment(invoice_payment)
        if !invoice_payment.has_key? "withdrawal"
            @error_message = invoice_payment 
            Payment.update(:completed => false)
            return false
        else
            return true
        end
    end

    def create_new_payment(sender, receiver, bitcoins_amount, invoice_id)
        Payment.create!(sender: sender, 
                        receiver: receiver, 
                        amount: bitcoins_amount,  
                        completed: true, 
                        invoice_id: invoice_id)    
    end

    def invoice_id_and_code(invoice)
        invoice_body = JSON.parse(invoice.body)
        invoice_id = invoice_body["invoice"]["id"]
        invoice_code = invoice_body["invoice"]["encoded_payment_request"]
        return invoice_id, invoice_code
    end

    def receiver_invoice(api_key, api_secret, bitcoins_amount)
        buda_receiver = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        buda_receiver.generate_invoice(bitcoins_amount)
    end

    def sender_payment(api_key, api_secret, bitcoins_amount, invoice_code)
        simulate = Rails.application.secrets.buda_payment_simulation
        buda_payer = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        buda_payer.pay_invoice(bitcoins_amount, invoice_code, simulate)
    end
end