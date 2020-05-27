class WithdrawalObserver < PowerTypes::Observer
  after_save :register_withdrawal

  def register_withdrawal
    RegisterWithdrawal.for(withdrawal: object)
  end
end
