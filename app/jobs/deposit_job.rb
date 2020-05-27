class DepositJob < ApplicationJob
  queue_as :default

  def perform(deposit)
    RegisterDeposit.for(deposit: deposit)
  end
end
