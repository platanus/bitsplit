class WithdrawalObserver < PowerTypes::Observer
  after_save :register_withdrawal

  def register_withdrawal
    WithdrawalJob.perform_later(object)
  end
end
