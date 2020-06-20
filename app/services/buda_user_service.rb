class BudaUserService < PowerTypes::Service.new(user: nil, api_key: nil, api_secret: nil)
  def generate_invoice(bitcoins_amount)
    success, message = validate_keys
    return message unless success
    path = '/api/v2/lightning_network_invoices'
    url = 'https://www.buda.com/api/v2/lightning_network_invoices'
    request_type = 'POST'
    satoshis = satoshi_price(bitcoins_amount)
    body = { amount_satoshis: satoshis, currency: 'BTC' }.to_json
    nonce = generate_nonce
    headers = generate_headers(@api_key, @api_secret, nonce, request_type, path, body)
    post_request(url, body, headers)
  end

  def pay_invoice(bitcoins_amount, invoice_code, simulate)
    success, message = validate_keys
    return message unless success
    path = '/api/v2/reserves/ln-btc/withdrawals'
    url = 'https://www.buda.com/api/v2/reserves/ln-btc/withdrawals'
    request_type = 'POST'
    body = { amount: bitcoins_amount, withdrawal_data: { payment_request: invoice_code } }
    # not included directly in body because if it is included, even being false, then simulated
    # is considered true by the api
    body[:simulate] = simulate if simulate == true
    body = body.to_json
    nonce = generate_nonce
    headers = generate_headers(@api_key, @api_secret, nonce, request_type, path, body)
    post_request(url, body, headers)
  end

  def balance(currency)
    success, message = validate_keys
    return message unless success
    path = '/api/v2/balances/' + currency
    url = 'https://www.buda.com/api/v2/balances/' + currency
    request_type = 'GET'
    nonce = generate_nonce
    headers = generate_headers(@api_key, @api_secret, nonce, request_type, path)
    get_request(url, headers)
  end

  def quotation(market_id, type, amount)
    url = 'https://www.buda.com/api/v2/markets/' + market_id + '/quotations'
    body = { type: type, amount: amount }
    post_request(url, body)
  end

  def get_btc_balance
    path = '/api/v2/balances/btc'
    url = 'https://www.buda.com/api/v2/balances/btc' 
    request_type = 'GET'
    nonce = generate_nonce
    headers = generate_headers(@api_key, @api_secret, nonce, request_type, path)
    get_request(url, headers)
  end

  def validate_keys
    balance_response = get_btc_balance
    unless balance_response.has_key? 'balance'
      error_message = balance_response
      user_params={"api_key": '' , "api_secret": ''}
      @user.update(user_params)
      return false, error_message
    end
    return true, "api_keys y api_secret correctas"
  end

  private

  def satoshi_price(bitcoins_amount)
    (bitcoins_amount * 100_000_000).round
  end

  def generate_nonce
    (Time.now.to_f.round(3) * 1000).to_i.to_s
  end

  def request_signature(api_secret, nonce, request_type, path, payload = nil)
    signature = signature(request_type, path, nonce, payload)
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha384'),
      api_secret, signature
    )
  end

  def signature(request_type, path, nonce, payload = nil)
    if payload.nil?
      "#{request_type} #{path} #{nonce}"
    else
      "#{request_type} #{path} #{Base64.strict_encode64(payload)} #{nonce}"
    end
  end

  def generate_headers(api_key, api_secret, nonce, request_type, path, payload = nil)
    {
      'X-SBTC-APIKEY' => api_key,
      'X-SBTC-NONCE' => nonce,
      'X-SBTC-SIGNATURE' => request_signature(api_secret, nonce, request_type, path, payload),
      'Content-Type' => 'application/json'
    }
  end

  def post_request(path, body, header = nil)
    params = { body: body }
    params[:headers] = header unless header.nil?
    HTTParty.post(path, body: body, headers: header)
  end

  def get_request(path, header)
    params = {}
    params[:headers] = header unless header.nil?
    HTTParty.get(path, headers: header)
  end
end
