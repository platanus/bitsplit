class RegisterDeposit < PowerTypes::Command.new(:deposit)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_user_deposit_satoshis_entry(
      tenant: tenant,
      document: @deposit,
      datetime: @deposit.created_at
    ) do
      debit(account: :vault, amount: @deposit.satoshis_in_deposit)
      credit(account: :wallet, accountable: @deposit.user, amount: @deposit.satoshis_in_deposit)
    end
  end

  private

  def tenant
    Tenant.find(ENV.fetch("MAIN_TENANT", 1))
  end
end
