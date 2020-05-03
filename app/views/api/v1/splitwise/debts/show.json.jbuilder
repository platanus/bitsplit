json.data do
    json.type "debts"
    json.attributes {
        json.user_to_friends @user_to_friends
        json.friends_to_user @friends_to_user
    }
end