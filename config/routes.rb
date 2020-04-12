# frozen_string_literal: true

Rails.application.routes.draw do

  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resource :sessions, only: [:create, :destroy]
      resource :users, only: [:show, :create, :destroy, :update]

    end

  end


  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  root 'home#index'

  get '/*path', to: 'home#index'

  get 'api/v1/quotations/index', to:'api/v1/quotations#index'
  devise_for :users

end

