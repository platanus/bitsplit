class LedgerizerService < PowerTypes::Service.new
  @error_message = 'error'

  def deposit(user, bitcoins)
    Deposit.create(user: user, satoshis: to_satoshis(bitcoins))
  end

  def withdrawal(user, bitcoins)
    satoshis = to_satoshis(bitcoins)
    return false, @error_message unless validate_amount(user, satoshis)
    Withdrawal.create(user: user, satoshis: satoshis)
    [true, @error_message]
  end

  def transfer(sender, receiver, bitcoins)
    satoshis = to_satoshis(bitcoins)
    return false, @error_message unless validate_receiver(sender, receiver)
    return false, @error_message unless validate_amount(sender, satoshis)
    Transfer.create(sender: sender,
      receiver: receiver, satoshis: to_satoshis(bitcoins))
    [true, @error_message]
  end

  def to_satoshis(bitcoins)
    bitcoins * 100_000_000
  end

  def validate_amount(user, amount)
    if amount <= 0
      @error_message = 'amount is less or equal to 0'
      return false
    end
    if user.wallet_balance < Money.from_amount(amount, 'SAT')
      @error_message = 'amount is greater than balance'
      return false
    end
    true
  end

  def validate_receiver(sender, receiver)
    if receiver.nil?
      @error_message = 'invalid receiver email'
      return false
    end
    if sender == receiver
      @error_message = 'you cannot transfer to yourself'
      return false
    end
    true
  end
end