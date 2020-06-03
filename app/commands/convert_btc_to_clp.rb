class ConvertBtcToClp < PowerTypes::Command.new(:amount)
  def perform
    market_id = 'BTC-CLP'
    buda_service = BudaUserService.new
    quotation = buda_service.quotation(market_id, 'ask_given_size', @amount)
    return 0 unless quotation.has_key? 'quotation'

    quotation['quotation']['quote_exchanged'][0]
  end
end
