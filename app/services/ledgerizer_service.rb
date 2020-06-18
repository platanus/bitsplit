class LedgerizerService < PowerTypes::Service.new
  @error_message = 'error'

  def deposit(user, bitcoins)
    Deposit.create(user: user, satoshis: to_satoshis(bitcoins))
  end

  def withdrawal(user, bitcoins)
    satoshis = to_satoshis(bitcoins)
    Withdrawal.create(user: user, satoshis: satoshis)
    [true, @error_message]
  end

  def transfer(sender, receiver, bitcoins)
    satoshis = to_satoshis(bitcoins)
    Transfer.create(sender: sender,
                    receiver: receiver, satoshis: to_satoshis(bitcoins))
    [true, @error_message]
  end

  def to_satoshis(bitcoins)
    bitcoins * 100_000_000
  end

end
