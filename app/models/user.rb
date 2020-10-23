class User < ApplicationRecord
  include LedgerizerAccountable

  self.ignored_columns = ['authentication_token']
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :token_authenticatable
  has_many :sent_payments, class_name: 'Payment', foreign_key: 'sender_id'
  has_many :received_payments, class_name: 'Payment', foreign_key: 'receiver_id'
  has_many :authentication_tokens, dependent: :delete_all
  has_many :notification_tokens, dependent: :delete_all

  def wallet_balance
    wallet_account&.balance || Money.from_amount(0, 'SAT')
  end

  def wallet_account
    accounts.find_by(name: :wallet)
  end

  def payments_record
    sent_payments + received_payments
  end

  def api_key
    decrypt(self[:api_key])
  end

  def api_secret
    decrypt(self[:api_secret])
  end

  def api_key=(text)
    super(encrypt(text))
  end

  def api_secret=(text)
    super(encrypt(text))
  end

  def splitwise_token
    decrypt(self[:splitwise_token])
  end

  def splitwise_token=(text)
    super(encrypt(text))
  end

  def splitwise_secret
    decrypt(self[:splitwise_secret])
  end

  def splitwise_secret=(text)
    super(encrypt(text))
  end

  def authenticated_with_splitwise
    !splitwise_secret.nil? || !splitwise_token.nil?
  end

  # source https://dev.to/shobhitic/simple-string-encryption-in-rails-36pi
  def encrypt(text)
    text = text.to_s unless text.is_a? String

    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end

  def decrypt(text)
    # note that to decrypt the api_secret the password is Rails.application.secrets.secret_key_base
    # if user has not yet setted a api_key or api_secret
    if text.nil?
      nil
    else
      salt, data = text.split '$$'

      len   = ActiveSupport::MessageEncryptor.key_len
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
      crypt = ActiveSupport::MessageEncryptor.new key
      crypt.decrypt_and_verify data
    end
  end

  def buda_keys
    api_key = decrypt(self.api_key)
    api_secret = decrypt(self.api_secret)
    [api_key, api_secret]
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  api_key                :string
#  api_secret             :string
#  logged                 :boolean          default(FALSE)
#  splitwise_token        :string
#  oauth_token            :string
#  oauth_secret           :string
#  splitwise_secret       :string
#  splitwise_user_id      :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
