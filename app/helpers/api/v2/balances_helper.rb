module Api::V2::BalancesHelper

  def generate_answer(buda_user)
    buda_answer_clp = buda_user.balance('clp')
    buda_answer_btc = buda_user.balance('btc')
    balance_buda_clp = buda_balance(buda_answer_clp )
    balance_buda_btc = buda_balance(buda_answer_btc)
    balance_bitsplit_btc = bitsplit_balance
    [balance_buda_clp, balance_buda_btc, balance_bitsplit_btc]
  end

  def buda_balance(balance_curr)
    {
      amount: balance_curr['balance']['amount'][0],
      available_amount: balance_curr['balance']['available_amount'][0],
      frozen_amount: balance_curr['balance']['frozen_amount'][0],
      pending_withdraw_amount: balance_curr['balance']['pending_withdraw_amount'][0]
    }
  end

  def bitsplit_balance
    satoshis = current_user.wallet_balance.amount
    amount = ConvertSatoshisToBitcoins.for(satoshis: satoshis)
    {
      'amount' => amount
    }
  end
  
end