# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  
  # exclude the creation of a user for token auth
  acts_as_token_authentication_handler_for User, except: [:create]

  def create
    respond_with User.create!(user_params)
  end


  def show
    respond_with current_user
  end


  def update
    respond_with current_user.update!(user_params)
  end


  def destroy
    @user = User.find_by_email(params[:email])
    if @user&.valid_password?(params[:password]) && @user.destroy
      respond_with @user.destroy!
    else
      head(:unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :api_key, :api_secret)
  end

end
