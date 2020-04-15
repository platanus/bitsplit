# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  type :user

  attributes(
    :id,
    :email,
    :api_key,
    :authentication_token
  )

  def api_key
    object.decrypt(object.api_key)
  end
end
