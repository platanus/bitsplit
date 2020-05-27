class WithdrawalJob < ApplicationJob
  queue_as :default

  def perform(withdrawal)
    RegisterWithdrawal.for(withdrawal: withdrawal)
  end
end
