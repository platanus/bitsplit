class Api::V2::ResetPasswordsController < ApplicationController
    before_action :authenticate_user!, except: [:create, :update]

    def create 
        #recibe email 
        user = User.find_by_email!(params[:email])
        @token = ResetPasswordService.new.create_reset_password_token(user)
    end 

    def update 
        #recibe token y password nueva 
        @user = User.find_by_reset_password_token!(params[:token])
        @user.update_attributes(password: params[:password])
    end 

    private

    def reset_passwords_params
      params.permit(:email, :token, :password)
    end
end