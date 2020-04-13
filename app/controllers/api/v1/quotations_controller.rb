class Api::V1::QuotationsController < ApplicationController
   
    def create 
        market_id = 'BTC-CLP'
        final_amount = params[:amount]
        quotation_agv = make_buda_quotation_request(market_id, 'ask_given_value', final_amount)
        btc_amount = quotation_agv['quotation']['base_exchanged'][0]
        quotation_bgs = make_buda_quotation_request(market_id, 'bid_given_size', btc_amount)
        return set_success_params(quotation_bgs) if quotation_bgs.has_key? "quotation"
        @error_message = quotation_bgs 
        render "error"
    end

    def make_buda_quotation_request(market_id, type, amount)
        HTTParty.post('https://www.buda.com/api/v2/markets/'+ market_id +'/quotations',
        :body => {
            'type': type,
            'amount': amount,
        }.to_json, :headers => {'Content-Type' => 'application/json'})
    end

    def set_success_params(quotation_bgs)
        @amount_clp = quotation_bgs['quotation']['quote_exchanged']
        @amount_btc = quotation_bgs['quotation']['amount'] 
    end

    private

    def quotation_params
        params.require(:amount)
    end
end
