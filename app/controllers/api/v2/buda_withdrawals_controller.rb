class Api::V2::BudaWithdrawalsController < ApplicationController
  
  def create
    if current_user.api_key && !decrypt(current_user.api_key).empty?
      api_key, api_secret = current_user.buda_keys
      buda_service = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      @invoice = buda_service.generate_invoice(params[:amount])
      satoshis_amount = satoshi_price(params[:amount])
      money_service = MoneyService.new
      amount_validation, message = money_service.validate_amount(current_user, satoshis_amount)
      @response = message
      return unless amount_validation
      new_user_withdrawal = UserWithdrawal.create!(user_id: current_user.id,
                                            amount: params[:amount], 
                                            completed: false,
                                            invoice: @invoice )
      response = opennode_service.send_withdrawal_request(@invoice, false)
      @response = JSON.parse(response.body)
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