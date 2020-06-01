class RegisterWithdrawal < PowerTypes::Command.new(:withdrawal)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_user_withdrawal_satoshis_entry(
      tenant: tenant,
      document: @withdrawal,
      datetime: @withdrawal.created_at
    ) do
      debit(account: :wallet, accountable: @withdrawal.user, amount: @withdrawal.satoshis_in_withdrawal)
      credit(account: :vault, amount: @withdrawal.satoshis_in_withdrawal)
    end
  end

  private

  def tenant
    Tenant.find(ENV.fetch('MAIN_TENANT', 1))
  end
end
