class RegisterDeposit < PowerTypes::Command.new(:deposit)
  include Ledgerizer::Execution::Dsl

  def perform
    
    execute_user_deposit_satoshis_entry(
      tenant: tenant,
      document: @deposit,
      datetime: @deposit.created_at
    ) do
      debit(account: :vault, amount: satoshis_in_deposit)
      credit(account: :wallet, accountable: @deposit.user, amount: satoshis_in_deposit)
    end
  end

  private

  def satoshis_in_deposit
    Money.from_amount(@deposit.satoshis, 'SAT')
  end

  def tenant
    Tenant.first
  end
end
