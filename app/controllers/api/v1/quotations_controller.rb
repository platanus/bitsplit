class Api::V1::QuotationsController < ApplicationController
    def index 
        render 'api/v1/quotations/index'
    end
end
