class Api::V2::ChargesController < Api::V2::BaseController
    # class Api::V2::ChargesController < ApplicationController

    CHARGES_API_KEY = 'insertar api key con permisos para charges'

    def create
        url ='https://api.opennode.co/v1/charges'
        headers={ 
            'Authorization' => CHARGES_API_KEY,
            'Content-Type' => 'application/json'
              }
        body = { amount: params[:amount], currency: params[:currency]}.to_json
        @response = post_request(url, body, headers)
    end

    def post_request(path, body, header)
        params = { body: body }
        params[:headers] = header
        HTTParty.post(path, body: body, headers: header)
    end
end