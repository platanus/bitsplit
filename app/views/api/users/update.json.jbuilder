json.data do
    json.user @user.as_json({:password => @password})
end