class Api::V2::BalancesController < ApplicationController
  def show
    api_key, api_secret = current_user.buda_keys
    buda_user = BudaUserService.new(api_key: api_key, api_secret: api_secret)
    unless buda_user.balance('btc').has_key? 'balance'
      @error_message = balance_btc
      render('error') && return
    end
    @balance_buda_clp, @balance_buda_btc, @balance_bitsplit_btc = helpers.generate_answer(buda_user)
  end
end
