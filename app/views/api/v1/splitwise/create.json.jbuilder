json.data do
    json.type "splitwise"
    json.attributes {
        json.authorize_url @request.authorize_url
    }
end