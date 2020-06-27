class ResetPasswordService < PowerTypes::Service.new

    def create_reset_password_token(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        #@token = raw
        user.reset_password_token = hashed
        user.reset_password_sent_at = Time.now.utc
        user.save
        raw
     end
end
