class DepositObserver < PowerTypes::Observer
  after_save :register_deposit

  def register_deposit
    DepositJob.perform_later(object)
  end
end
