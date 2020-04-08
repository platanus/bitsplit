json.data do
    json.user do
        json.email @user.email
        json.api_key @user.api_key
        json.api_secret @user.api_secret
    end
end