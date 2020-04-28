class Api::V1::Splitwise::DebtsController < ApplicationController
    
    before_action :generate_splitwise_service

    def show 
        return if !current_user.authenticated_with_splitwise
        @user_groups = @splitwise_service.get_current_user_groups
    end
    
    private
    def generate_splitwise_service
      @splitwise_service = SplitwiseService.new(user: current_user)
    end 
end
