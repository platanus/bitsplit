class LedgerizerService < PowerTypes::Service.new

    def self.deposit(user, bitcoins)
        deposit = Deposit.create(user: user, satoshis: to_satoshis(bitcoins))
        RegisterDeposit.for(deposit: deposit)
    end 

    def self.withdrawal(user, bitcoins)
        withdrawal = Withdrawal.create(user: user, satoshis: to_satoshis(bitcoins))
        RegisterWithdrawal.for(withdrawal: withdrawal)
    end

    def self.transfer(sender, receiver, bitcoins)
        transfer = Transfer.create(sender: sender, receiver: receiver, satoshis: to_satoshis(bitcoins))
        RegisterTransfer.for(transfer: transfer)
    end

    def self.user_balance(user)
        account = user.wallet_account
        account.balance
    end

    def self.to_satoshis(bitcoins)
        bitcoins * 100000000
    end
end
