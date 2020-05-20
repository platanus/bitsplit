class LedgerizerService < PowerTypes::Service.new
  @error_message = 'error'

  def self.deposit(user, bitcoins)
    deposit = Deposit.create(user: user,
                             satoshis: to_satoshis(bitcoins))
    RegisterDeposit.for(deposit: deposit)
  end

  def self.withdrawal(user, bitcoins)
    satoshis = to_satoshis(bitcoins)
    return false, @error_message unless self.validate_amount(user, satoshis)
    withdrawal = Withdrawal.create(user: user, satoshis: satoshis)
    RegisterWithdrawal.for(withdrawal: withdrawal)
    [true, @error_message]
  end

  def transfer(sender, receiver, bitcoins)
    satoshis = to_satoshis(bitcoins)
    return false, @error_message unless self.validate_amount(sender, satoshis)
    transfer = Transfer.create(sender: sender,
                               receiver: receiver, satoshis: to_satoshis(bitcoins))
    RegisterTransfer.for(transfer: transfer)
    [true, @error_message]
  end

  def user_balance(user)
    account = user.wallet_account
    account.balance
  end

  def to_satoshis(bitcoins)
    bitcoins * 100_000_000
  end

  def validate_amount(user, amount)
    if self.user_balance(user) < Money.from_amount(amount, 'SAT')
      @error_message = 'amount is greater than balance'
      return false
    end
    true
  end
end
