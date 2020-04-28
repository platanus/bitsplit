class Api::V1::Splitwise::DebtsController < ApplicationController
    
    def show 
        return if current_user.splitwise_secret.nil? || current_user.splitwise_token.nil?
        splitwise_service = SplitwiseService.new(user: current_user)
        @user_groups = splitwise_service.get_current_user_groups
    end 
end
