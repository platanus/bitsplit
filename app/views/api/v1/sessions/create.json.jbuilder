json.data do
    json.id @user.id.to_s
    json.type "session"
    json.attributes {
        json.email @user.email
        json.api_key @user.decrypt(@user.api_key)
        json.authentication_token @user.authentication_token
    }
end