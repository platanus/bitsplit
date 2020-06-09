class Api::V2::BalancesController < ApplicationController
  def show
    if current_user.api_key && !decrypt(current_user.api_key).empty?
      api_key, api_secret = current_user.buda_keys
      buda_user = BudaUserService.new(api_key: api_key, api_secret: api_secret)
      unless buda_user.balance('btc').has_key? 'balance'
        @error_message = buda_user.balance('btc')
        render('error') && return
      end
    end
    balance_service = BalanceService.new
    @balance_buda_clp, @balance_buda_btc, @buda_btc_clp,
    @balance_bitsplit_btc, @balance_bitsplit_btc_clp = balance_service.get_buda_and_bitsplit_balances(current_user, buda_user)
  end

  private

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
