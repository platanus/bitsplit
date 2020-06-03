class Api::V2::BalancesController < ApplicationController
    
  def show
    if current_user.api_key
      api_key, api_secret = current_user.buda_keys
      buda_user = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      unless buda_user.balance('btc').has_key? 'balance'
        @error_message = balance_btc
        render('error') && return
      end
    end
    @balance_buda_clp, @balance_buda_btc, @buda_btc_clp, 
    @balance_bitsplit_btc, @balance_bitsplit_btc_clp = helpers.generate_answer(buda_user)
  end
    
end