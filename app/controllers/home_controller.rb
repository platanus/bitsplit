class HomeController < ApplicationController
    #before_action :authenticate_user!, except: :index
    acts_as_token_authentication_handler_for User, except: [:index]

    def index;
    end
end