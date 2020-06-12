class OpenNodeService < PowerTypes::Service.new
  # Service code goes here

  def send_charge_request(amount, currency, order_id)
    url = url('/v1/charges')
    webhook_url = ENV.fetch('DEPOSIT_WEBHOOK_URL')
    headers = headers(@charges_api_key)
    body = { amount: amount, currency: currency, order_id: order_id }.to_json
    if order_id != nil
      body = { amount: amount, currency: currency, order_id: order_id, callback_url: webhook_url }.to_json
    end
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
