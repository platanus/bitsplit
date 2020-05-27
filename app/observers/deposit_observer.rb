class DepositObserver < PowerTypes::Observer
  after_save :register_deposit

  def register_deposit
    RegisterDeposit.for(deposit: object)
  end
end
