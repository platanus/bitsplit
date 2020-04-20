class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def api_key=(text)
    super(self.encrypt(text))
  end
     
  def api_secret=(text)
    super(self.encrypt(text))
  end

  def splitwise_token
    self.decrypt(self[:splitwise_token])
  end

  def splitwise_token=(text)
    super(self.encrypt(text))
  end

  def splitwise_secret
    self.decrypt(self[:splitwise_secret])
  end

  def splitwise_secret=(text)
    super(self.encrypt(text))
  end

  # source https://dev.to/shobhitic/simple-string-encryption-in-rails-36pi
  def encrypt text
    text = text.to_s unless text.is_a? String
  
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end
  
  def decrypt text
    # note that to decrypt the api_secret the password is Rails.application.secrets.secret_key_base
    # if user has not yet setted a api_key or api_secret
    if text.nil?
      nil
    else
      salt, data = text.split "$$"
    
      len   = ActiveSupport::MessageEncryptor.key_len
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
      crypt = ActiveSupport::MessageEncryptor.new key
      crypt.decrypt_and_verify data
    end
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
#  authentication_token   :string(30)
#  api_key                :string
#  api_secret             :string
#  logged                 :boolean          default(FALSE)
#  splitwise_token        :string
#  oauth_token            :string
#  oauth_secret           :string
#  splitwise_secret       :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
