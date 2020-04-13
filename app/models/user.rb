class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # source https://dev.to/shobhitic/simple-string-encryption-in-rails-36pi
  def encrypt text, password
    text = text.to_s unless text.is_a? String
  
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(password).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end
  
  def decrypt text, password
    # if user has not yet setted a api_key or api_secret
    if text.nil?
      nil
    else
      salt, data = text.split "$$"
    
      len   = ActiveSupport::MessageEncryptor.key_len
      key   = ActiveSupport::KeyGenerator.new(password).generate_key salt, len
      crypt = ActiveSupport::MessageEncryptor.new key
      crypt.decrypt_and_verify data
    end
  end

  def as_json(options={})
    # one option is the password that has to be passed
    # to decrypt the api_key
    json = super(options)

    if options.has_key?(:password)
      # replace the encrypted api_key with decrypted one
      json[:api_key] = decrypt(json["api_key"], options[:password])

    # if the password is not provided, then the api_key is removed
    # from the json output, as this is sensitive information
    else
      json.delete("api_key")
    end

    # always delete :id as it is only used internaly, but has to be exposed
    # for the creation of the user
    json.delete("id")
    # delete null fields (private ones) and returns the cleaned data
    json.compact
  end

  private

  # private readers will not be rendered in json
  attr_reader :api_secret, :created_at, :updated_at

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
#  authentication_token   :string(30)
#  api_key                :string
#  api_secret             :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
