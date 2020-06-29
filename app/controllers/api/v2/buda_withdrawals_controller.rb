class Api::V2::BudaWithdrawalsController < ApplicationController
  
  def create
    if current_user.api_key && !decrypt(current_user.api_key).empty?
      api_key, api_secret = current_user.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      response = buda_service.generate_invoice(params[:amount])
      invoice = JSON.parse(response.body)['invoice']['encoded_payment_request']
      money_service = MoneyService.new
      render(json: { error: 'invalid buda invoice' }, status: 400) and return unless money_service.check_buda_invoice_creation(response)
      render(json: { invoice: invoice }, status: 200)
    else
      render(json: { error: 'user does not have synchronized Buda' }, status: 400) 
    end
  end

  private

  def buda_withdrawals_params
    params.permit(:amount)
  end

  def satoshi_price(bitcoins_amount)
    (bitcoins_amount * 100_000_000).round
  end

  def decrypt(text)
    if text.nil?
      nil
    else
      salt, data = text.split '$$'
      len   = ActiveSupport::MessageEncryptor.key_len
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
      crypt = ActiveSupport::MessageEncryptor.new key
      crypt.decrypt_and_verify data
    end
  end
end