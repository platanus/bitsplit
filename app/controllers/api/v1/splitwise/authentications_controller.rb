class Api::V1::Splitwise::AuthenticationsController < ApplicationController

  # the token verification is skiped for show as this
  # path is used by Splitwise to return the information
  # as a callback

  # this can be changed in the future by changing the callback
  # route that is in the splitwise api form
  acts_as_token_authentication_handler_for User, except: [:show]
  before_action :generate_splitwise_service, except: [:show]

  def create
    @request = @splitwise_service.token_initializer
    render :create, status: :ok
  end

  def show
    @user = User.find_by(oauth_token: params[:oauth_token])
    @splitwise_service = SplitwiseService.new(user: @user)
    @splitwise_service.grant_access(params)
    render head(:no_content)
  end

  private
  def generate_splitwise_service
    @splitwise_service = SplitwiseService.new(user: current_user)
  end

end
