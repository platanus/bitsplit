module Api::V1::Splitwise::DebtsHelper
  def generate_answer(user_groups, user_friends)
    user_id = current_user.splitwise_user_id
    user_to_friends = []
    friends_to_user = []
    user_groups['groups'].each do |group|
      group['original_debts'].each do |debt|
        if debt['from'] == user_id
          insert_debt_info(user_to_friends, debt, group, user_friends)
        elsif debt['to'] == user_id
          insert_debt_info(friends_to_user, debt, group, user_friends)
        end
      end
    end
    [user_to_friends, friends_to_user]
  end

  def insert_debt_info(list, debt, group, user_friends)
    from_user_id = debt['from']
    to_user_id = debt['to']
    from_user_info = get_user_info(user_friends, from_user_id)
    to_user_info = get_user_info(user_friends, to_user_id)
    is_payable = false
    is_payable = true if check_user_has_bitsplit(from_user_id) && check_user_has_bitsplit(to_user_id)
    debt[:group_id] = group['id']
    debt[:group_name] = group['name']
    debt[:from] = from_user_info
    debt[:to] = to_user_info
    debt[:is_payable] = is_payable
    list.push(debt)
  end

  def get_user_info(user_friends, user_id)
    user_info = {}
    user_friends.each do |friend|
      next unless friend['id'] == user_id

      user_info =
        {
          'id' => friend['id'],
          'first_name' => friend['first_name'],
          'last_name' => friend['last_name'],
          'picture' => friend['picture']['small'],
          'email' => friend['email']
        }
    end
    user_info
  end

  def check_user_has_bitsplit(user_id)
    User.exists?(splitwise_user_id: user_id)
  end
end
