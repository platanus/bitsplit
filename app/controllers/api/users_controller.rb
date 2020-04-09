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
                params[:api_secret] = @user.encrypt(params[:api_secret], params[:password])
            end

            # checks if the email exists already in the database
            if user_params.has_key?(:email)
                if not email_in_use(:email)
                    if @user.update user_params
                        render :update
                    else
                        head(:unprocessable_entity)
                    end
                else
                    head(:unprocessable_entity)
                end
            else            
                if @user.update user_params
                    render :update
                else
                    head(:unprocessable_entity)
                end
            end
        else
            head(:unauthorized)
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