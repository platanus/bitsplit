class Api::V2::ChargesController < Api::V2::BaseController
    # class Api::V2::ChargesController < ApplicationController
    
    def create
        request = OpenNodeService.new(charges_api_key: ENV.fetch("OPENNODE_CHARGES_KEY"))
        @response = request.send_charge_request(params[:amount], params[:currency])
    end
end
