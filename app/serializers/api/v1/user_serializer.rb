# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  type :user

  attributes(
    :id,
    :email,
    :api_key,
    :authentication_token,
    :picture_url,
  )

  def api_key
    object.decrypt(object.api_key)
  end

  def picture_url
    return if object.splitwise_secret.nil? || object.splitwise_token.nil?

    splitwise_service = SplitwiseService.new(user: object)
    user_info = splitwise_service.get_current_user_info
    user_info[:user][:picture]
end
