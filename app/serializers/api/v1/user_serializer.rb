# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  type :user

  attributes(
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :created_at,
    :updated_at,
    :api_key,
    :api_secret,
    :authentication_token
  )
end
