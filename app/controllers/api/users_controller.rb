class Api::UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
        @user = User.new(user_params)

        if @user.save
            render :create
        else
            head(:unprocessable_entity)
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_cofirmation)
    end
    
end