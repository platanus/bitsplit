class Api::V2::WithdrawalsController < Api::V2::BaseController
    # class Api::V2::WithdrawalsController < ApplicationController

    WITHDRAWALS_API_KEY = '308365d0-e46c-48ac-ad3a-3c43cd5cd8ae'

    def create
        url ='https://api.opennode.co/v2/withdrawals'
        headers={ 
            'Authorization' => CHARGES_API_KEY,
            'Content-Type' => 'application/json'
              }
        amount=params[:amount]
        satoshi_amount=amount
        body = { type: 'ln', address: params[:invoice]}.to_json
        @response = post_request(url, body, headers)
    end

end