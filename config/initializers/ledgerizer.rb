Ledgerizer.setup do |conf|
    conf.tenant(:tenant, currency: :sat) do
        # where bitsplit keeps the bitcoins (like a bank account)
        conf.asset :vault
      
        # bitsplit incomes for withdrawal services ?????
        # conf.income :withdrawal_fees
      
        # where users keep their bitcoins. Is a liability for bitsplit, because bitsplit
        # should pay back the equivalent in bitcoins.
        conf.liability :wallet
      
        # when users deposit bitcoins into bitsplit
        conf.entry :user_deposit_satoshis, document: :deposit do
          # increases the amount of bitcoins in the vault
          conf.debit account: :vault
          # increases debt of bitcoins for a specific user
          conf.credit account: :wallet, accountable: :user
        end
      
        # when users withdraw their bitcoins from bitsplit
        conf.entry :user_withdrawal_satoshis, document: :withdrawal do
          # decreases debt of bitcoins to a specific user
          conf.debit account: :wallet, accountable: :user
          # decreases the amount of bitcoins in the vault
          conf.credit account: :vault
          # increases bitsplit's incomes ????
          #conf.credit account: :withdrawal_fees
        end
      
        # when users transfer bitcoins to other user
        conf.entry :user_transfer_satoshis, document: :transfer do
          # decreases debt of bitcoins to a specific user
          conf.debit account: :wallet, accountable: :user
          # increases debt of bitcoins for a specific user
          conf.credit account: :wallet, accountable: :user
        end

    end
end

# Example:
#
# Ledgerizer.setup do |conf|
#   conf.tenant(:portfolio) do
#     conf.asset :bank
#     conf.liability :funds_to_invest
#     conf.liability :to_invest_in_fund
#
#     conf.entry :user_deposit, document: :user_deposit do
#       conf.debit account: :bank, accountable: :bank
#       conf.credit account: :funds_to_invest, accountable: :user
#     end
#
#     conf.entry :user_deposit_distribution, document: :user_deposit do
#       conf.debit account: :funds_to_invest, accountable: :user
#       conf.credit account: :to_invest_in_fund, accountable: :user
#     end
#   end
# end
