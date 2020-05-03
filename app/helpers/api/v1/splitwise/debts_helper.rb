module Api::V1::Splitwise::DebtsHelper
   
    def generate_answer(user_groups)
        user_id = current_user.splitwise_user_id
        user_to_friends = []
        friends_to_user = []
        user_groups['groups'].each do |group|
            group['original_debts'].each do |debt|
                if debt['from'] == user_id
                    insert_debt_info(user_to_friends, debt, group)
                elsif debt['to'] == user_id
                    insert_debt_info(friends_to_user, debt, group)
                end
            end
        end
        return user_to_friends, friends_to_user
    end

    def insert_debt_info(list, debt, group)
        from_user_id = debt['from']
        to_user_id = debt['to']
        from_user_info = get_user_info(group['members'], from_user_id)
        to_user_info = get_user_info(group['members'], to_user_id)
        is_payable = false
        if check_user_has_bitsplit(from_user_id) && check_user_has_bitsplit(to_user_id) 
            is_payable = true
        end
        debt[:group_id] = group['id']
        debt[:group_name] = group['name']
        debt[:from] = from_user_info
        debt[:to] = to_user_info
        debt[:is_payable] = is_payable
        list.push(debt)
    end

    def get_user_info(members, user_id)
        user_info = {}
        members.each do |member| 
            if member['id'] == user_id
                user_info = 
                {
                    'id' => member['id'],
                    'first_name' => member['first_name'],
                    'last_name' => member['last_name'], 
                    'picture' => member['picture']['small'],
                    'email' => member['email'] 
                }
            end
        end
        return user_info
    end

    def check_user_has_bitsplit(user_id)
        User.exists?(:splitwise_user_id => user_id)
    end    

end
