class Api::V1::SessionsController < Devise::SessionsController
    # exclude the creation of a session for token auth
    before_action :authenticate_user!, except: [:create]

    def create
      user = warden.authenticate!(auth_options)
      token = Tiddle.create_and_return_token(user, request)
      render json: { authentication_token: token }
    end
  
    def destroy
      if current_user && Tiddle.expire_token(current_user, request)
        head :ok
      else
        # Client tried to expire an invalid token
        render json: { error: 'invalid token' }, status: 401
      end
    end
  
    private  
    # this is invoked before destroy and we have to override it
    def verify_signed_out_user
    end
end