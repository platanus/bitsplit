class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    request = OpenNodeService.new
    response = request.send_withdrawal_request(params[:invoice])
    data = JSON.parse(response.body)['data']
    if data.has_key? 'id'
      satoshis_amount = data['amount'].to_f
      btc_amount = (satoshis_amount/ 100000000).to_f
      ledgerizer = LedgerizerService.new
      ledgerizer.withdrawal(current_user, btc_amount)
    end
    @response = response
  end
end
