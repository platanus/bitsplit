# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  type :user

  attributes(
    :id,
    :email,
    :name,
    :last_name,
    :birth_date,
    :picture,
    :api_key,
    :picture_url,
    :wallet
  )

  def picture_url
    return unless object.authenticated_with_splitwise

    splitwise_service = SplitwiseService.new(user: object)
    user_info = splitwise_service.current_user_info
    user_info[:user][:picture]
  end
end
