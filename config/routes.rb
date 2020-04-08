Rails.application.routes.draw do

  root 'home#index'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    resource :sessions, only: [:create, :destroy]
    resource :users, only: [:show, :create, :destroy, :update]
  end
end
