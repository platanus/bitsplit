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
    if (user_params.has_key?(:api_key) || user_params.has_key?(:api_secret))
      if !current_user&.valid_password?(params[:password])
        # user does not have the correct password => cannot update correctly
        respond_with({error:"incorrect password" }, :status => 400) && return 
      else
        buda_user = BudaUserService.new(user: current_user, api_key: params[:api_key], api_secret: params[:api_secret])
        success, message = buda_user.validate_keys
        respond_with({error: message}, :status => 400) && return unless success
      end
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
    params.permit(:email, :password, :password_confirmation, :api_key, :api_secret, :wallet, :name, :last_name, :birth_date, :picture)
  end
end
