class Api::UsersController < ApplicationController

    # exclude the creation of a user for token auth
    acts_as_token_authentication_handler_for User, except: [:create]

    def create
        @user = User.new(user_params)

        if @user.save
            render :create
        else
            head(:unprocessable_entity)
        end
    end


    def destroy
        @user = User.find_by_email(params[:email])
        if @user&.valid_password?(params[:password]) && @user.destroy
            render :destroy
        else
            head(:unauthorized)
        end
    end

    private

    def user_params
        params.permit(:email, :password, :password_cofirmation)
    end
    
end