class Api::V1::QuotationsController < ApplicationController
  def create
    market_id = 'BTC-CLP'
    final_amount = params[:amount]
    buda_user = BudaUserService.new
    quotation_agv = buda_user.quotation(market_id, 'ask_given_value', final_amount)
    btc_amount = quotation_agv['quotation']['base_exchanged'][0]
    quotation_bgs = buda_user.quotation(market_id, 'bid_given_size', btc_amount)
    unless quotation_bgs.has_key? 'quotation'
      @error_message = quotation_bgs
      render('error') && return
    end
    success_params(quotation_bgs)
  end

  def success_params(quotation_bgs)
    @amount_clp = quotation_bgs['quotation']['quote_exchanged']
    @amount_btc = quotation_bgs['quotation']['amount']
  end

  private

  def quotation_params
    params.require(:amount)
  end
end
