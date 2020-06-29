class ResetPasswordService < PowerTypes::Service.new

    def create_reset_password_token(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        #@token = raw
        user.reset_password_token = hashed
        user.reset_password_sent_at = Time.now.utc
        user.save
        hashed
    end
    def decrypt(text)
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


end
