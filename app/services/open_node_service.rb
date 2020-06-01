class OpenNodeService < PowerTypes::Service.new
  # Service code goes here

  def send_charge_request(amount, currency)
    url = url('/v1/charges')
    headers = headers(@charges_api_key)
    # 100,000,000 satoshis = 1 btc
    amount_satoshis = (amount * 100_000_000).to_i
    body = { amount: amount_satoshis, currency: currency }.to_json
    post_request(url, body, headers)
  end

  def send_withdrawal_request(invoice)
    url = url('/v2/withdrawals')
    headers = headers(@withdrawals_api_key)
    body = { type: 'ln', address: invoice }.to_json
    post_request(url, body, headers)
  end

  def url(path)
    "https://api.opennode.co#{path}"
  end

  def post_request(path, body, header)
    params = { body: body }
    params[:headers] = header
    HTTParty.post(path, body: body, headers: header)
  end

  private

  def initialize
    @charges_api_key =  ENV.fetch('OPENNODE_CHARGES_KEY')
    @withdrawals_api_key = ENV.fetch('OPENNODE_WITHDRAWALS_KEY')
  end

  def headers(api_key)
    {
      'Authorization' => api_key,
      'Content-Type' => 'application/json'
    }
  end
end
