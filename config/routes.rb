# frozen_string_literal: true

Rails.application.routes.draw do

  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resource :sessions, only: [:create, :destroy]
      resource :users, only: [:show, :create, :destroy, :update]
      resource :quotations, only: [:create]
    end

  end


  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  if Rails.env.development?
    mount RailsDb::Engine => '/rails/db', :as => 'rails_db'
  end

  devise_for :users

  root 'home#index'

  get '/*path', to: 'home#index'


end

