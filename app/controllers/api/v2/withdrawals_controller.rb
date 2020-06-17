class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    opennode_service = OpenNodeService.new
    amount_response = opennode_service.get_invoice_amount(params[:invoice])
    satoshis_amount = JSON.parse(amount_response.body)['data']['pay_req']['amount'].to_f
    money_service=MoneyService.new
    amount_validation, message = money_service.validate_amount(current_user, satoshis_amount)
    if !amount_validation
      @response = message
      return
    end
    response = opennode_service.send_withdrawal_request(params[:invoice])
    response_body = JSON.parse(response.body)
    if !response_body.has_key? 'data'
      @response = response_body
      return
    end
    if response_body['data'].has_key? 'id'
      btc_amount = (satoshis_amount/ 100000000).to_f
      ledgerizer = LedgerizerService.new
      ledgerizer.withdrawal(current_user, btc_amount)
    end
    @response = response_body
  end
end
