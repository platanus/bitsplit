class Api::V2::BudaPaysController < ApplicationController
  def create
    if current_user.api_key && !decrypt(current_user.api_key).empty?
      amount = UserDeposit.find_by(id: params[:order_id]).amount
      api_key, api_secret = current_user.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      simulate = ENV.fetch('INVOICE_PAYMENT_SIMULATION')
      @payment = buda_service.pay_invoice(amount, params[:invoice], simulate)
    else
      render(json: { error: 'user does not have synchronized Buda' }, status: 400) 
    end
  end

  private

  def buda_pays_params
    params.permit(:invoice, :order_id)
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