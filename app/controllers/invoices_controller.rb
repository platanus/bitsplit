class InvoicesController < ApplicationController

    def self.create_new_invoice(bitcoins_amount, api_key, api_secret)

        path = '/api/v2/lightning_network_invoices'
        url='https://www.buda.com/api/v2/lightning_network_invoices'
        request_type = 'POST'
        satoshis = self.satoshi_price(bitcoins_amount)
        body={ amount_satoshis: satoshis, currency: 'BTC' }.to_json
        nonce=BudaRequestsController.generate_nonce
        headers=BudaRequestsController.headers(api_key, api_secret, nonce,request_type, path ,body)
        BudaRequestsController.post_request(url, body, headers)

    end

    def self.pay_new_invoice(bitcoins_amount, invoice_code, simulate, api_key, api_secret)
        path = '/api/v2/currencies/BTC/withdrawals'
        url='https://www.buda.com/api/v2/currencies/BTC/withdrawals'
        request_type = 'POST'
        body={ amount: bitcoins_amount, reserve_code: 'ln-btc', withdrawal_data:{payment_request:invoice_code}, simulate: simulate }.to_json
        nonce=BudaRequestsController.generate_nonce
        headers=BudaRequestsController.headers(api_key, api_secret, nonce,request_type, path ,body)
        BudaRequestsController.post_request(url, body,headers)
    end


    def self.satoshi_price(bitcoins_amount)
        btc_price= bitcoins_amount
        if btc_price!= 0
        (btc_price * 100_000_000).round
        end
    end


end