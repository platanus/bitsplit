class Api::V1::BalancesController < ApplicationController

    def show
        user = current_user
        api_key = user.decrypt(user.api_key)
        api_secret = user.decrypt(user.api_secret)
        buda_user = BudaUserService.new(api_key: api_key, api_secret: api_secret)
        balance_clp = buda_user.balance('clp')
        balance_btc = buda_user.balance('btc')
        if !balance_btc.has_key? "balance"
            @error_message = balance_btc
            render "error"
        end
        return set_success_params(balance_clp, balance_btc) 
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
