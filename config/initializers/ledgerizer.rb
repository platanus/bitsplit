Ledgerizer.setup do |conf|
    conf.tenant(:tenant, currency: :sat) do
        conf.asset :vault
        conf.liability :wallet

        conf.entry :user_deposit_satoshis, document: :deposit do
          conf.debit account: :vault
          conf.credit account: :wallet, accountable: :user
        end
      
        conf.entry :user_withdrawal_satoshis, document: :withdrawal do
          conf.debit account: :wallet, accountable: :user
          conf.credit account: :vault
        end
      
        conf.entry :user_transfer_satoshis, document: :transfer do
          conf.debit account: :wallet, accountable: :user
          conf.credit account: :wallet, accountable: :user
        end
    end
end

Ledgerizer.definition.running_inside_transactional_fixtures = true
