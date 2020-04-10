# frozen_string_literal: true

USER_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: '1' },
    type: { type: :string, example: 'user' },
    attributes: {
      type: :object,
      properties: {
        email: { type: :string, example: 'Some email' },
        encrypted_password: { type: :string, example: 'Some encrypted_password', 'x-nullable': true },
        reset_password_token: { type: :string, example: 'Some reset_password_token', 'x-nullable': true },
        reset_password_sent_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        remember_created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        api_key: { type: :string, example: 'Some api_key', 'x-nullable': true },
        api_secret: { type: :string, example: 'Some api_secret', 'x-nullable': true },
        authentication_token: { type: :string, example: 'Some authentication_token', 'x-nullable': true }
      },
      required: [
        :email
      ]
    }
  },
  required: %i[
    id
    type
    attributes
  ]
}.freeze

USERS_COLLECTION_SCHEMA = {
  type: 'object',
  properties: {
    data: {
      type: 'array',
      items: { '$ref' => '#/definitions/user' }
    }
  },
  required: [
    :data
  ]
}.freeze

USER_RESOURCE_SCHEMA = {
  type: 'object',
  properties: {
    data: { '$ref' => '#/definitions/user' }
  },
  required: [
    :data
  ]
}.freeze
