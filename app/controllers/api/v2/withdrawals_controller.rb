class Api::V2::WithdrawalsController < Api::V2::BaseController
  # class Api::V2::WithdrawalsController < ApplicationController

  def create
    opennode_service = OpenNodeService.new
    amount_response = opennode_service.get_invoice_amount(params[:invoice])
    amount_response_body = JSON.parse(amount_response.body)
    @response = amount_response_body
    return unless amount_response_body.has_key? 'data'
    return unless amount_response_body['data'].has_key? 'pay_req'
    satoshis_amount = amount_response_body['data']['pay_req']['amount'].to_f
    money_service = MoneyService.new
    amount_validation, message = money_service.validate_amount(current_user, satoshis_amount)
    @response = message
    return unless amount_validation
    response = opennode_service.send_withdrawal_request(params[:invoice], false)
    response_body = JSON.parse(response.body)
    @response = response_body
    return unless response_body.has_key? 'data'
    return unless response_body['data'].has_key? 'id'
    btc_amount = (satoshis_amount/ 100000000).to_f
    ledgerizer = LedgerizerService.new
    ledgerizer.withdrawal(current_user, btc_amount)
  end
end
