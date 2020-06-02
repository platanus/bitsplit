class ConvertBtcToClp < PowerTypes::Command.new(:amount)
    
    def perform
        market_id = 'BTC-CLP'
        buda_service = BudaUserService.new
        quotation = buda_service.quotation(market_id, 'ask_given_size', @amount)
        unless quotation.has_key? 'quotation'
          @error_message = quotation
          render('error') && return
        end
        quotation
    end

end