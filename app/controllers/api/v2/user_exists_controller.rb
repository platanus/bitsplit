class Api::V2::UserExistsController < ApplicationController
    before_action :authenticate_user!, except: [:create]

    def create 
        @user_exists = !User.find_by_email(params[:email]).nil?
    end 

    private

    def user_exists_params
      params.permit(:email)
    end
end