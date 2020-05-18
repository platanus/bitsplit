class Api::V1::PaymentSerializer < ActiveModel::Serializer
  type :payment

  attributes(
    :id,
    :sender_email,
    :receiver_email,
    :amount,
    :completed,
    :invoice_id,
    :created_at
  )

  def receiver_email
    User.where(id: object['receiver_id']).first.email
  end

  def sender_email
    User.where(id: object['sender_id']).first.email
  end
end
