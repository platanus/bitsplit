class RegisterTransfer < PowerTypes::Command.new(:transfer)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_user_transfer_satoshis_entry(
      tenant: tenant,
      document: @transfer,
      datetime: @transfer.created_at
    ) do
      debit(account: :wallet, accountable: @transfer.sender, amount: satoshis_in_transfer)
      credit(account: :wallet, accountable: @transfer.receiver, amount: satoshis_in_transfer)
    end
  end

  private

  def satoshis_in_transfer
    Money.from_amount(@transfer.satoshis, 'SAT')
  end

  def tenant
    Tenant.first
  end
end
