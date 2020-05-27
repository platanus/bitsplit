class TransferObserver < PowerTypes::Observer
  after_save :register_transfer

  def register_transfer
    TransferJob.perform_later(object)
  end
end
