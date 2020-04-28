class Api::V1::Splitwise::DebtsController < ApplicationController
    
    before_action :generate_splitwise_service

    def show 
        return if !current_user.authenticated_with_splitwise
        @user_groups = @splitwise_service.get_current_user_groups
    end

    def create
        response = @splitwise_service.payoff_debt(params[:group_id], params[:to_user_id], params[:amount])
        if response.code == "200"
          head(:created)
        else
          head(:unauthorized)
        end
    end
    
    private
    def generate_splitwise_service
      @splitwise_service = SplitwiseService.new(user: current_user)
    end
end
