class BalanceService < PowerTypes::Service.new
  def get_buda_and_bitsplit_balances(user, buda_user)
    clp_equivalence_btc = ConvertBtcToClp.for(amount: 1).to_f
    balance_buda_clp, balance_buda_btc, buda_btc_clp = get_buda_balance(buda_user, clp_equivalence_btc)
    balance_bitsplit_btc, balance_bitsplit_btc_clp = get_bitsplit_balance(user, clp_equivalence_btc)
    [balance_buda_clp, balance_buda_btc, buda_btc_clp, balance_bitsplit_btc, balance_bitsplit_btc_clp]
  end

  def get_buda_balance(buda_user, clp_equivalence_btc)
    buda_answer_clp = buda_user&.balance('clp')
    buda_answer_btc = buda_user&.balance('btc')
    balance_buda_clp = buda_balance_info(buda_answer_clp)
    balance_buda_btc = buda_balance_info(buda_answer_btc)
    buda_btc_clp = buda_balance_btc_to_clp_info(balance_buda_btc, clp_equivalence_btc)
    [balance_buda_clp, balance_buda_btc, buda_btc_clp]
  end

  def get_bitsplit_balance(user, clp_equivalence_btc)
    balance_bitsplit_btc = bitsplit_balance_info(user, 1)
    balance_bitsplit_btc_clp = bitsplit_balance_info(user, clp_equivalence_btc)
    [balance_bitsplit_btc, balance_bitsplit_btc_clp]
  end

  def buda_balance_info(balance_curr)
    balance = balance_curr&.[]('balance')
    {
      amount: balance&.[]('amount')&.[](0) || '0.0',
      available_amount: balance&.[]('available_amount')&.[](0) || '0.0',
      frozen_amount: balance&.[]('frozen_amount')&.[](0) || '0.0',
      pending_withdraw_amount: balance&.[]('pending_withdraw_amount')&.[](0) || '0.0'
    }
  end

  def buda_balance_btc_to_clp_info(balance_buda_btc, clp_equivalence_btc)
    balance_buda_btc.map do |key, value|
      [key, (clp_equivalence_btc * value.to_f).to_s]
    end.to_h
  end

  def bitsplit_balance_info(user, factor)
    satoshis = user.wallet_balance.amount
    amount = ConvertSatoshisToBitcoins.for(satoshis: satoshis)
    {
      'amount' => amount * factor
    }
  end
end
