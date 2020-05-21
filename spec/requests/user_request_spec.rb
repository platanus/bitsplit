require 'rails_helper'

RSpec.describe User, type: :request do
  
  user_params = {"email" => "user@example.com", "password" =>"password", "password_confitmation" => "password", "api_secret" => "api_secret", "api_key" => "api_key"}

  describe "CRUD" do

    before(:all) do
      AuthenticationToken.delete_all
      User.delete_all
      @post_response = create_user(user_params)
      @post_response_body = get_response_body(@post_response)
      @auth_token = get_auth_token(user_params)
    end

    before(:each) do
      auth_token = get_by_attribute(@post_response_body, "authentication_token")
      @headers = create_headers(user_params["email"], auth_token)
    end

    describe "POST: create user and return its corresponding data" do
      it "should have created status" do 
        expect(@post_response).to have_http_status(:created)
      end
      it "should have user type" do
        expect(@post_response_body["data"]["type"]).to eq "user"
      end

      it "should still be the same data" do
        expect(@post_response_body["data"]["attributes"]).to include("email" => user_params["email"], "api_key" => user_params["api_key"])
      end
      
      it "should not include password or api_secret" do
        expect(@post_response_body["data"]["attributes"]).not_to (have_key("password") && have_key("api_secret"))
      end
    end

    describe "GET: current user" do
      before(:each) do
        get "/api/v1/users", headers: @headers
        @response_body = get_response_body(response)
      end
      xit "should still be the same data" do
        expect(@response_body["data"]["attributes"]).to include("email" => user_params["email"], "api_key" => user_params["api_key"])
      end
      xit "should not include password or api_secret" do
        expect(@response_body["data"]["attributes"]).not_to (have_key("password") && have_key("api_secret"))
      end
    end

    describe "PATCH: current user" do
      new_email = "newuser@example.com"
      new_api_key = "new_api_key"

      context "with password" do
        before(:each) do
          patch "/api/v1/users", headers: @headers, params: {"email" => new_email, "api_key": new_api_key, "password" => user_params["password"]}
          @response_body = get_response_body(response)
        end
        xit "should have new data" do
          expect(@response_body["data"]["attributes"]).to include("email" => new_email, "api_key" => new_api_key)
        end
        xit "should not include password or api_secret" do
          expect(@response_body["data"]["attributes"]).not_to (have_key("password") && have_key("api_secret"))
        end
      end
      
      context "without password" do
        before(:each) do
          patch "/api/v1/users", headers: @headers, params: {"email" => new_email, "api_key": new_api_key}
          @response = response
        end
        xit "should get bad request" do
          expect(@response).to have_http_status(:bad_request)
        end
      end
    end

    describe "DELETE: current user" do
      before(:each) do
        delete "/api/v1/users", headers: @headers, params: {"email" => user_params["email"], "password" => user_params["password"]}
        @reponse = response
      end
      xit "should be deleted" do
        expect(@response).to have_http_status(:success)
      end
    end 

    after(:all) do
      AuthenticationToken.delete_all
      User.delete_all
    end

  end

  def get_by_attribute(json, param)
    json["data"]["attributes"][param]
  end
  
  def create_user(user_params)
    post  "/api/v1/users", params: user_params
    return response
  end

  def get_auth_token(user_params)
    post  "/api/v1/sessions", params: { user: {email: user_params["email"], password: user_params["password"]} }, headers: { "Content-Type": "application/json"}
    # TODO: get token and fix tests
  end
  
  def get_response_body(response)
    return JSON.parse(response.body)
  end
  
  def create_headers(email, auth_token)
    { "X-User-Email" => email, "X-User-Token": auth_token }
  end
end