class BudaUserService < PowerTypes::Service.new(api_key: nil, api_secret: nil)


  def generate_invoice(bitcoins_amount)
    path = '/api/v2/lightning_network_invoices'
    url ='https://www.buda.com/api/v2/lightning_network_invoices'
    request_type = 'POST'
    satoshis = satoshi_price(bitcoins_amount)
    body ={ amount_satoshis: satoshis, currency: 'BTC' }.to_json
    nonce = generate_nonce
    headers = headers(@api_key, @api_secret, nonce, request_type, path ,body)
    post_request(url, body, headers)
  end

  def pay_invoice(bitcoins_amount, invoice_code, simulate)
    path = '/api/v2/currencies/BTC/withdrawals'
    url ='https://www.buda.com/api/v2/currencies/BTC/withdrawals'
    request_type = 'POST'
    body = { amount: bitcoins_amount, reserve_code: 'ln-btc', withdrawal_data:{payment_request: invoice_code}, simulate: simulate }.to_json
    nonce = generate_nonce
    headers = headers(@api_key, @api_secret, nonce,request_type, path ,body)
    post_request(url, body, headers)

  end 

  def balance(currency)
    path = '/api/v2/balances/'+ currency
    url ='https://www.buda.com/api/v2/balances/' + currency
    request_type = 'GET'
    nonce = generate_nonce
    headers = headers(@api_key, @api_secret, nonce, request_type, path)
    get_request(url, headers)

  end

  def quotation(market_id, type, amount)
    url ='https://www.buda.com/api/v2/markets/'+ market_id +'/quotations'
    body = { type: type, amount: amount}
    post_request(url, body)

  end

  private

  def satoshi_price(bitcoins_amount)
      (bitcoins_amount * 100_000_000).round
  end

  def generate_nonce
    (Time.now.to_f.round(3) * 1000).to_i.to_s
  end

  def request_signature(api_secret, nonce, request_type, path, payload = nil)
      signature = self.signature(request_type, path, nonce, payload)
      OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha384'),
      api_secret, signature)
  end

  def signature(request_type, path, nonce, payload = nil)
      if payload.nil?
        "#{request_type} #{path} #{nonce}"
      else
        "#{request_type} #{path} #{Base64.strict_encode64(payload)} #{nonce}"
      end
  end

  def headers(api_key, api_secret, nonce, request_type, path, payload = nil)
    { 
    'X-SBTC-APIKEY' => api_key ,
    'X-SBTC-NONCE' => nonce,
    'X-SBTC-SIGNATURE' => request_signature(api_secret, nonce, request_type, path, payload),
    'Content-Type' => 'application/json'
      }
  end

  def post_request(path, body , header = nil)
    params = { body: body }
    params[:headers] = header unless header.nil?
    HTTParty.post(path, body: body, headers: header)
  end

  def get_request(path, header)
    params={}
    params[:headers] = header unless header.nil?
    HTTParty.get(path, headers: header)
  end

end
