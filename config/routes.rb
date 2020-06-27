# frozen_string_literal: true

Rails.application.routes.draw do

  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      devise_scope :user do
        resource :sessions, only: [:create, :destroy]
      end
      resource :users, only: [:show, :create, :destroy, :update]
      resource :quotations, only: [:create]
      resource :balances, only: [:show]
      resource :payments, only: [:create, :show]
      resource :firebase, only: [:update]

      namespace :splitwise do
        resource :authentications, only: [:show, :create]
        resource :debts, only: [:show, :create]
      end

    end
    api_version(module: 'Api::V2', path: { value: 'v2' }, defaults: { format: 'json' }) do
      resource :deposits, only: [:create]
      resource :withdrawals, only: [:create]
      resource :transfers, only: [:create]
      resource :balances, only: [:show]
      resource :push_notifications, only: [:create]
      resource :transactions, only: [:show]
      resource :depositwebhooks, only: [:create]
      resource :buda_pays, only: [:create]
      resource :withdrawals_webhook, only: [:create]
      resource :reset_passwords, only: [:create, :update]

    end
  end
  
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  
  if Rails.env.development?
    mount RailsDb::Engine => '/rails/db', :as => 'rails_db'
  end
  
  devise_for :user
  root 'home#index'

  get '/*path', to: 'home#index'


end

