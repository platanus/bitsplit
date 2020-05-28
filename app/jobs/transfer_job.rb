class TransferJob < ApplicationJob
  queue_as :default

  def perform(transfer)
    RegisterTransfer.for(transfer: transfer)
  end
end
