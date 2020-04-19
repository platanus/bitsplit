require 'oauth-plugin'

class SplitwiseService < PowerTypes::Service.new(:user)
  
  def token_initializer
    request = consumer.get_request_token
    update_user(:oauth_token, request.token)
    update_user(:oauth_secret, request.secret)
    return request
  end

  private
  def update_user(field, value)
    @user.update_attribute(field, value)
  end

  def consumer
    _secrets = Rails.application.secrets
    @c ||= OAuth::Consumer.new(_secrets.splitwise_consumer_key, _secrets.splitwise_consumer_secret, {
      :site => _secrets.splitwise_base_site,
      :scheme => :header,
      :http_method => :post,
      :authorize_path => _secrets.splitwise_authorize_url,
      :request_token_path => _secrets.splitwise_token_url,
      :access_token_path => _secrets.splitwise_access_token_url
      })
  end

end