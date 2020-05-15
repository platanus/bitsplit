class LedgerizerService < PowerTypes::Service.new


    def self.simulate
        tenant = Tenant.create(:name => "Bitsplit")
        user = User.create(:email=>"example@ex.com", :password=> "holaexample", 
        :password_confirmation=>"holaexample", :tenant=> tenant)
        deposit(user, 1000)
    
    end

    def self.deposit(user, satoshis)
        deposit = Deposit.create(user: user, satoshis: satoshis)
        RegisterDeposit.for(deposit: deposit)
    end 

    def self.withdrawal(user, satoshis)
        withdrawal = Withdrawal.create(user: user, satoshis: satoshis)
        RegisterDeposit.for(withdrawal: withdrawal)
    end

    def self.transfer(sender, receiver, satoshis)
        transfer = Transfer.create(sender: sender, receiver: receiver, satoshis: satoshis)
        RegisterDeposit.for(transfer: transfer)
    end

    def self.user_balance(user)
        account = user.wallet_account
        account.balance
    end

end
