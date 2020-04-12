class Api::V1::QuotationsController < ApplicationController
   
    def create 
        type = 'bid_given_value'
        market_id = 'BTC-CLP'
        quotation = (HTTParty.post('https://www.buda.com/api/v2/markets/'+ market_id +'/quotations',
        :body => {
            'type': type,
            'amount': params[:amount],
        }.to_json, :headers => {'Content-Type' => 'application/json'}))
       @amount = quotation['quotation']['amount']
       @base_balance_change = quotation['quotation']['base_balance_change']   
    end

    private

    def quotation_params
        params.require(:amount)
    end
end
