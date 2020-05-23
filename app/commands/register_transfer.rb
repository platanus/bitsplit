class RegisterTransfer < PowerTypes::Command.new(:transfer)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_user_transfer_satoshis_entry(
      tenant: tenant,
      document: @transfer,
      datetime: @transfer.created_at
    ) do
      debit(account: :wallet, accountable: @transfer.sender, amount: @transfer.satoshis_in_transfer)
      credit(account: :wallet, accountable: @transfer.receiver, amount: @transfer.satoshis_in_transfer)
    end
  end

  private

  def tenant
    Tenant.find(ENV.fetch("MAIN_TENANT", 1))
  end
end
