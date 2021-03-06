class Api::V2::ResetPasswordsController < ApplicationController
    before_action :authenticate_user!, except: [:create, :update]

    def create 
        user = User.find_by_email(params[:email])
        if user
            @token = ResetPasswordService.new.create_reset_password_token(user)
            UserMailer.with(user: user, token: @token).recover_password.deliver_now
        else
            @error_message = "invalid email"
            render 'error', status: 400
        end
    end 

    def update
        @user = User.find_by_reset_password_token(params[:token])
        if @user 
            @user.update_attributes(password: params[:password])
            UserMailer.with(user: @user).password_recovered.deliver_now
        else 
            @error_message = "invalid token"
            render 'error', status: 400
        end 
    end

    private

    def reset_passwords_params
      params.permit(:email, :token, :password)
    end
end