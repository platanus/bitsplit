# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  
  # exclude the creation of a user for token auth
  acts_as_token_authentication_handler_for User, except: [:create]

  def create
      @user = User.new(user_params)

      if @user.save
        # user can create with initial api information
        # updates user information directly with the corresponding encryption
        if user_params.has_key?(:api_key)
          @user.update_attribute(:api_key, @user.encrypt(user_params[:api_key], user_params[:password]))
        end
        if user_params.has_key?(:api_secret)
          @user.update_attribute(:api_secret, @user.encrypt(user_params[:api_secret,], Rails.application.secrets.secret_key_base))
        end
        render :create
      else
        head(:unprocessable_entity)
      end
  end


  def show
      @user = current_user

      if @user
          render :show
      else
          head(:unprocessable_entity)
      end
  end


  def update
      @user = current_user

      if @user&.valid_password?(params[:password])
        @password = params[:password]
        # special case if updating api_key or api_secret
        # reassign encrypted values in params
        # so that the user objects updates with the encrypted data
        if user_params.has_key?(:api_key)
            params[:api_key] = @user.encrypt(params[:api_key], params[:password])
        end
        if user_params.has_key?(:api_secret)
            params[:api_secret] = @user.encrypt(params[:api_secret], Rails.application.secrets.secret_key_base)
        end
      end

      if (user_params.has_key?(:api_key) || user_params.has_key?(:api_secret))
        # has fields and valid password => can correctly update fields
        if @user&.valid_password?(params[:password])
          if @user.update user_params
            render :update
          else
            head(:unprocessable_entity)
          end

        # user does not have the correct password => cannot update correctly
        else
          head(:bad_request)        
        end

      else
        if @user.update user_params
          render :update
        else
          head(:unprocessable_entity)
        end
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
      params.permit(:email, :password, :password_confirmation, :api_key, :api_secret)
  end

  def email_in_use(email)
      return User.exists?(:email => email)
  end

end
