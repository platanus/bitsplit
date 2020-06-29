json.data do
    json.type "reset_password"
    json.attributes do
        json.email @user.email
        json.password @user.password
    end
end