require 'rails_helper'

RSpec.describe "Users", type: :request do
  
  user_params = {"email" => "user@example.com", "password" =>"password", "password_confitmation" => "password", "api_secret" => "api_secret", "api_key" => "api_key"}

  describe "Expected responses (all correct)" do

    it "Create a user and returns its corresponding data" do
      post  "/api/v1/users", params: user_params
      expect(response).to have_http_status(:created)
      response_body = JSON.parse(response.body)
      expect(response_body["data"]["type"]).to eq "user"

      # test if data is still the same
      expect(response_body["data"]["attributes"]).to include("email" => "user@example.com", "api_key" => "api_key")
      # must return auth_token
      expect(response_body["data"]["attributes"]).to have_key("authentication_token")
      
      # do not include password or api_secret
      expect(response_body["data"]["attributes"]).not_to (have_key("password") && have_key("api_secret"))
    end

    it "Delete a user" do
      post  "/api/v1/users", params: user_params
      response_body = JSON.parse(response.body)
      auth_token = get_by_attribute(response_body, "authentication_token")

      delete "/api/v1/users", headers: { "X-User-Email" => user_params["email"], "X-User-Token": auth_token }, params: {"email" => user_params["email"], "password" => user_params["password"]}
      expect(response).to have_http_status(:no_content)
    end 

  end

  private

  def get_by_attribute(json, param)
    json["data"]["attributes"][param]
  end

  def create_user(user_params)
    post  "/api/v1/users", params: user_params
    return response
  end

  def get_response_body(response)
    return JSON.parse(response.body)
  end

  def create_headers(email, auth_token)
    { "X-User-Email" => email, "X-User-Token": auth_token }
  end
end