class BudaRequestsController < ApplicationController

    def self.generate_nonce
        (Time.now.to_f.round(3) * 1000).to_i.to_s
    end

    def self.request_signature(api_secret, nonce, request_type, path, payload = nil)
        signature = self.signature(request_type, path, nonce, payload)
        OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha384'),
        api_secret, signature)
    end

    def self.signature(request_type, path, nonce, payload = nil)
        if payload.nil?
          "#{request_type} #{path} #{nonce}"
        else
          "#{request_type} #{path} #{Base64.strict_encode64(payload)} #{nonce}"
        end
    end


  def self.headers(api_key, api_secret, nonce, request_type, path, payload = nil)
      { 
      #faltaria desencriptar la api_key
      'X-SBTC-APIKEY' => api_key ,
      'X-SBTC-NONCE' => nonce,
      'X-SBTC-SIGNATURE' => request_signature(api_secret, nonce, request_type, path, payload),
      'Content-Type' => 'application/json'
        }
  end


  def self.post_request(path, body, header)
    params = { body: body }
    params[:headers] = header unless header.nil?
    HTTParty.post(path, :body=>body, :headers=> header)
  end




end
