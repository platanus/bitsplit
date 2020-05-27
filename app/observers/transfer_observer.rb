class TransferObserver < PowerTypes::Observer
  after_save :register_transfer

  def register_transfer
    RegisterTransfer.for(transfer: object)
  end
end
