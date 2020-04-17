class Api::V1::BalancesController < ApplicationController

    def show
        user = current_user
        api_key = user.decrypt(user.api_key)
        api_secret = user.decrypt(user.api_secret)
        currency = 'clp'
        nonce = BudaAuthenticationsController.generate_nonce
        signature = BudaAuthenticationsController.request_signature(
                    api_secret, nonce, 'GET', '/api/v2/balances/' + currency)
        balance_clp = make_buda_balance_request(api_key, nonce, signature, currency)
        currency = 'btc'
        nonce = BudaAuthenticationsController.generate_nonce
        signature = BudaAuthenticationsController.request_signature(
                    api_secret, nonce, 'GET', '/api/v2/balances/' + currency)
        balance_btc = make_buda_balance_request(api_key, nonce, signature, currency)
        return set_success_params(balance_clp, balance_btc) if balance_btc.has_key? "balance"
        @error_message = balance_btc
        render "error"
    end 

    def make_buda_balance_request(api_key, nonce, signature, currency)
        HTTParty.get('https://www.buda.com/api/v2/balances/' + currency,
        :headers => { 
            'X-SBTC-APIKEY' => api_key,
            'X-SBTC-NONCE' => nonce,
            'X-SBTC-SIGNATURE' => signature,
            'Content-Type' => 'application/json'
              })
    end

    def set_success_params(balance_clp, balance_btc)
        @balance_clp = {amount: balance_clp['balance']['amount'][0], 
        available_amount: balance_clp['balance']['available_amount'][0],
        frozen_amount: balance_clp['balance']['frozen_amount'][0],
        pending_withdraw_amount: balance_clp['balance']['pending_withdraw_amount'][0]
    }
        @balance_btc = {amount: balance_btc['balance']['amount'][0], 
        available_amount: balance_btc['balance']['available_amount'][0],
        frozen_amount: balance_btc['balance']['frozen_amount'][0],
        pending_withdraw_amount: balance_btc['balance']['pending_withdraw_amount'][0]
    } 
    end
end
