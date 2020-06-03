module Api::V2::BalancesHelper

  def generate_answer(buda_user)
    clp_equivalence_btc = ConvertBtcToClp.for(amount: 1).to_f
    buda_answer_clp = buda_user&.balance('clp')
    buda_answer_btc = buda_user&.balance('btc')
    balance_buda_clp = buda_balance(buda_answer_clp)
    balance_buda_btc = buda_balance(buda_answer_btc)
    buda_btc_clp = balance_buda_btc_to_clp(balance_buda_btc, clp_equivalence_btc)
    balance_bitsplit_btc = bitsplit_balance(1)
    balance_bitsplit_btc_clp = bitsplit_balance(clp_equivalence_btc)
    [balance_buda_clp, balance_buda_btc, buda_btc_clp, 
    balance_bitsplit_btc, balance_bitsplit_btc_clp]
  end

  def buda_balance(balance_curr)
    {
      amount: balance_curr&['balance']&['amount'][0] || "0.0",
      available_amount: balance_curr&['balance']&['available_amount'][0] || "0.0",
      frozen_amount: balance_curr&['balance']&['frozen_amount'][0] || "0.0",
      pending_withdraw_amount: balance_curr&['balance']&['pending_withdraw_amount'][0] || "0.0"
    }
  end

  def balance_buda_btc_to_clp(balance_buda_btc, clp_equivalence_btc)
    hash = {}
    balance_buda_btc.keys.each do |key|
      hash[key] = (clp_equivalence_btc * balance_buda_btc[key].to_f).to_s
    end
    hash
  end

  def bitsplit_balance(factor)
    satoshis = current_user.wallet_balance.amount
    amount = ConvertSatoshisToBitcoins.for(satoshis: satoshis)
    {
      'amount' => amount * factor
    }
  end
  
end