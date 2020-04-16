class PaymentsController < ApplicationController

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


    def create_new_invoice(bitcoins_amount, api_key, api_secret)

        path = '/api/v2/lightning_network_invoices'
        url='https://www.buda.com/api/v2/lightning_network_invoices'
        request_type = 'POST'
        satoshis = satoshi_price(bitcoins_amount)
        body={ amount_satoshis: satoshis, currency: 'BTC' }.to_json
        nonce=generate_nonce
        headers=headers(api_key, api_secret, nonce,request_type, path ,body)
        post_request(url, body, headers)

    end

    def pay_new_invoice(bitcoins_amount, invoice_code, simulate, api_key, api_secret)
        path = '/api/v2/currencies/BTC/withdrawals'
        url='https://www.buda.com/api/v2/currencies/BTC/withdrawals'
        request_type = 'POST'
        body={ amount: bitcoins_amount, reserve_code: 'ln-btc', withdrawal_data:{payment_request:invoice_code}, simulate: simulate }.to_json
        nonce=generate_nonce
        headers=headers(api_key, api_secret, nonce,request_type, path ,body)
        @payment=post_request(url, body,headers)
    end

    def satoshi_price(bitcoins_amount)
        btc_price= bitcoins_amount
        if btc_price!= 0
        (btc_price * 100_000_000).round
        end
    end

    def post_request(path, body, header)
        params = { body: body }
        params[:headers] = header unless header.nil?
        HTTParty.post(path, :body=>body, :headers=> header)
    end

    
    def headers(api_key, api_secret, nonce, request_type, path, payload = nil)
        { 
        #faltaria desencriptar la api_key
        'X-SBTC-APIKEY' => api_key ,
        'X-SBTC-NONCE' => nonce,
        'X-SBTC-SIGNATURE' => request_signature(api_secret, nonce, request_type, path, payload),
        'Content-Type' => 'application/json'
          }
    end

    def generate_nonce
        (Time.now.to_f.round(3) * 1000).to_i.to_s
    end

    def request_signature(api_secret, nonce, request_type, path, payload = nil)
        signature=signature(request_type, path, nonce, payload)
        OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha384'),
        api_secret, signature)
    end

    def signature(request_type, path, nonce, payload = nil)
        if payload.nil?
          "#{request_type} #{path} #{nonce}"
        else
          "#{request_type} #{path} #{Base64.strict_encode64(payload)} #{nonce}"
        end
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

