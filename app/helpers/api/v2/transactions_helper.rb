module Api::V2::TransactionsHelper
  def generate_answer(user_friends)
    clp_equivalence_btc = ConvertBtcToClp.for(amount: 1).to_f
    transactions = current_user.wallet_account&.ledger_lines
    return [] if transactions.nil?

    transactions_list = []
    transactions.each do |line|
      transaction = transaction_info(line, user_friends, clp_equivalence_btc)
      transactions_list.push(transaction)
    end
    transactions_list
  end

  def transaction_info(line, user_friends, clp_equivalence_btc)
    sender, receiver = get_sender_receiver_info(line, user_friends)
    amount_btc = ConvertSatoshisToBitcoins.for(satoshis: line.amount_cents.to_f).abs
    amount_clp = amount_btc * clp_equivalence_btc
    {
      'id' => line.id,
      'type' => line.document_type,
      'attributes' => {
        'created_at' => line.entry_time,
        'amount_btc' => amount_btc,
        'amount_clp' => amount_clp,
        'sender' => sender,
        'receiver' => receiver
      }
    }
  end

  def get_sender_receiver_info(line, user_friends)
    sender_id = line.accountable_id
    receiver_id = sender_id
    if line.document_type == 'Transfer'
      sender_id = line.document.sender_id
      receiver_id = line.document.receiver_id
    end
    sender = get_user_info(line, user_friends, sender_id)
    receiver = get_user_info(line, user_friends, receiver_id)
    [sender, receiver]
  end

  def get_user_info(_line, user_friends, user_id)
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
