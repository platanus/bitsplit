# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  # exclude the creation of a user for token auth
  before_action :authenticate_user!, except: [:create]

  def create
    new_user = User.create!(user_params)
    respond_with new_user
  end

  def show
    respond_with current_user
  end

  def update
    if (user_params.has_key?(:api_key) || user_params.has_key?(:api_secret)) && !current_user&.valid_password?(params[:password])
      # user does not have the correct password => cannot update correctly
      head(:bad_request)
    else
      current_user.update(user_params)
      respond_with current_user
    end
  end

  def destroy
    @user = User.find_by_email(params[:email])
    if @user&.valid_password?(params[:password]) && @user&.destroy
      respond_with @user.destroy!
    else
      head(:unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :api_key, :api_secret, :wallet)
  end
end
