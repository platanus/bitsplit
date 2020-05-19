class OpenNodeService < PowerTypes::Service.new(charges_api_key: nil, withdrawals_api_key: nil)
  # Service code goes here

  def send_charge_request (amount, currency)
    url = 'https://api.opennode.co/v1/charges'
    headers={ 
        'Authorization' => @charges_api_key,
        'Content-Type' => 'application/json'
          }
    body = { amount: amount, currency: currency}.to_json
    post_request(url, body, headers)
  end

  def send_withdrawal_request (invoice)
    url ='https://api.opennode.co/v2/withdrawals'
    headers={ 
        'Authorization' => @withdrawals_api_key,
        'Content-Type' => 'application/json'
          }
    body = { type: 'ln', address: invoice}.to_json
    post_request(url, body, headers)
  end

  def post_request(path, body, header)
    params = { body: body }
    params[:headers] = header
    HTTParty.post(path, body: body, headers: header)
  end

end
