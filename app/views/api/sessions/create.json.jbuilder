json.data do
    json.user do
        json.authentication_token @user.authentication_token
        json.email @user.email
        json.api_key @user.decrypt(@user.api_key, @password)
    end
end