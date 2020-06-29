json.data do
    json.type "reset_password"
    json.attributes do
        json.token @token
    end
end