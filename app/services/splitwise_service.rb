require 'oauth-plugin'

class SplitwiseService < PowerTypes::Service.new(:user)

  @@current_user_info_url = 'https://www.splitwise.com/api/v3.0/get_current_user'
  @@current_user_groups_url = 'https://www.splitwise.com/api/v3.0/get_groups'
  @@current_user_expenses_url = 'https://secure.splitwise.com/api/v3.0/get_expenses'
  @@create_expense_url = 'https://secure.splitwise.com/api/v3.0/create_expense'

  def token_initializer
    request = consumer.get_request_token
    update_user(:oauth_token, request.token)
    update_user(:oauth_secret, request.secret)
    return request
  end

  def grant_access(params)
    request_token = OAuth::RequestToken.new(consumer, params[:oauth_token], @user.oauth_secret)
    access = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    update_user(:splitwise_token, access.token)
    update_user(:splitwise_secret, access.secret)
    update_user(:splitwise_user_id, get_current_user_info[:user][:id])
  end
  
  # POST methods from Splitwise API

  def payoff_debt(params)
    post_to_splitwise(@@create_expense_url, {
      "cost": params[:amount],
      "payment": true,
      "group_id": params[:group_id],
      "description": "Pago hecho a traves de BitSplit",
      "users__0__user_id": @user.splitwise_user_id,
      "users__0__paid_share": params[:amount],
      "users__1__user_id": params[:to_user_id],
      "users__1__owed_share": params[:amount]
      })
  end

  # GET methods from Splitwise API

  def get_current_user_info
    get_from_splitwise(@@current_user_info_url)
  end

  def get_current_user_groups
    get_from_splitwise(@@current_user_groups_url)
  end

  def get_current_user_expenses
    get_from_splitwise(@@current_user_expenses_url)
  end
  
  private
  def get_from_splitwise(url)
    JSON.parse(generate_access_token.get(url).body).with_indifferent_access
  end

  def post_to_splitwise(url, params = {})
    generate_access_token.post(url, params)
  end

  def generate_access_token
    OAuth::AccessToken.new(consumer, @user.splitwise_token, @user.splitwise_secret)
  end

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