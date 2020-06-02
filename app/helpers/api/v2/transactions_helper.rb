module Api::V2::TransactionsHelper

  def generate_answer(user_friends)
    transactions = current_user.wallet_account.ledger_lines
    transactions_list = []
    transactions.each do |line|
      transaction = transaction_info(line, user_friends)
      transactions_list.push(transaction)
    end
    transactions_list
  end

  def transaction_info(line, user_friends)
    amount = ConvertSatoshisToBitcoins.for(satoshis: line.amount_cents.to_f).abs
    if line.document_type == 'Transfer'
      sender_id = line.document.sender_id
      receiver_id = line.document.receiver_id
    else
      sender_id = line.accountable_id
      receiver_id = sender_id
    end
    sender = get_user_info(line, user_friends, sender_id)
    receiver = get_user_info(line, user_friends, receiver_id)
    transaction =
    {
      'id' => line.id,
      'type' => line.document_type,
      'attributes'=> {
          'created_at' => line.entry_time,
          'amount' => amount,
          'sender' => sender,
          'receiver' => receiver
      }
    }
  end

  def get_transfer_users_info(line, user_friends)
    sender = {}
    receiver = {}
    tenant.ledger_lines(line: line).each do |user_line|
      if user_line.amount_cents < 0
        sender = get_user_info(user_line, user_friends)
      else 
        receiver = get_user_info(user_line, user_friends)        
      end
    end 
    [sender, receiver]
  end

  def get_user_info(line, user_friends, user_id)
    email = User.find_by_id(user_id).email
    user_info =
    {
      'id' => user_id,
      'email' => email,
      'first_name' => '',
      'last_name' => '',
      'picture' => ''
    }
    if current_user.splitwise_user_id && User.find_by_id(user_id).splitwise_user_id
      user_info['first_name'], user_info['last_name'], user_info['picture'] = 
      get_splitwise_user(user_friends, user_id)
    end
    user_info
  end

  def get_splitwise_user(user_friends, user_id)
    splitwise_user_id = User.find_by_id(user_id).splitwise_user_id
    user_info = {}
    user_friends.each do |friend|
      next unless friend['id'] == splitwise_user_id
      user_info = [friend['first_name'], friend['last_name'], friend['picture']['small']]
    end
    user_info
  end
  
  private

  def tenant
    Tenant.find(ENV.fetch('MAIN_TENANT', 1))
  end
  
end

