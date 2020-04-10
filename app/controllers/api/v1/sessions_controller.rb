class Api::V1::SessionsController < Api::V1::BaseController

    # exclude the creation of a session for token auth
    acts_as_token_authentication_handler_for User, except: [:create]

    def create
        @user = User.where(email: params[:email]).first

        if @user&.valid_password?(params[:password])
            @password = params[:password]
            render :create, status: :created
        else
            head(:unauthorized)
        end
    end

    def destroy
        current_user&.authentication_token = nil
        if current_user.save
            head(:ok)
        else
            head(:unauthorized)
        end
    end
end