require 'oauth-plugin'

class SplitwiseService < PowerTypes::Service.new(:user)

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
    create_expense_url = 'https://secure.splitwise.com/api/v3.0/create_expense'
    post_to_splitwise(create_expense_url, {
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
    current_user_info_url = 'https://www.splitwise.com/api/v3.0/get_current_user'
    get_from_splitwise(current_user_info_url)
  end

  def get_current_user_friends
    current_user_friends_url = 'https://www.splitwise.com/api/v3.0/get_friends'
    get_from_splitwise(current_user_friends_url)
  end

  def get_current_user_groups
    current_user_groups_url = 'https://www.splitwise.com/api/v3.0/get_groups'
    get_from_splitwise(current_user_groups_url)
  end

  def get_current_user_expenses
    current_user_expenses_url = 'https://secure.splitwise.com/api/v3.0/get_expenses'
    get_from_splitwise(current_user_expenses_url)
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
    splitwise_key = ENV.fetch("SPLITWISE_CONSUMER_KEY")
    splitwise_secret = ENV.fetch("SPLITWISE_CONSUMER_SECRET")
    @c ||= OAuth::Consumer.new(splitwise_key, splitwise_secret, {
      :site => 'https://secure.splitwise.com',
      :scheme => :header,
      :http_method => :post,
      :authorize_path => '/authorize',
      :request_token_path => '/api/v3.0/get_request_token',
      :access_token_path => '/api/v3.0/get_access_token'
      })
  end

end