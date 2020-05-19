class RegisterWithdrawal < PowerTypes::Command.new(:withdrawal)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_user_withdrawal_satoshis_entry(
      tenant: tenant,
      document: @withdrawal,
      datetime: @withdrawal.created_at
    ) do
      debit(account: :wallet, accountable: @withdrawal.user, amount: satoshis_in_withdrawal)
      credit(account: :vault, amount: satoshis_in_withdrawal)
    end
  end

  private

  def satoshis_in_withdrawal
    Money.from_amount(@withdrawal.satoshis, 'SAT')
  end

  def tenant
    Tenant.first
  end
end
