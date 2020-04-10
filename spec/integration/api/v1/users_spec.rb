# frozen_string_literal: true

require 'swagger_helper'

describe 'API V1 Users', swagger_doc: 'v1/swagger.json' do
  path '/users' do
    get 'Retrieves Users' do
      description 'Retrieves all the users'
      produces 'application/json'

      let(:collection_count)          { 5                }
      let(:expected_collection_count) { collection_count }

      before { create_list(:user, collection_count) }

      response '200', 'Users retrieved' do
        schema('$ref' => '#/definitions/users_collection')

        run_test! do |response|
          expect(JSON.parse(response.body)['data'].count).to eq(expected_collection_count)
        end
      end
    end

    post 'Creates User' do
      description 'Creates User'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :user, in: :body)

      response '201', 'user created' do
        let(:user) do
          {
            email: 'Some email'
          }
        end

        run_test!
      end

      response '400', 'invalid attributes' do
        let(:user) do
          {
            email: nil
          }
        end

        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :integer

    let(:existent_user) { create(:user) }
    let(:id) { existent_user.id }

    get 'Retrieves User' do
      produces 'application/json'

      response '200', 'user retrieved' do
        schema('$ref' => '#/definitions/user_resource')

        run_test!
      end

      response '404', 'invalid user id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates User' do
      description 'Updates User'
      consumes 'application/json'
      produces 'application/json'
      parameter(name: :user, in: :body)

      response '200', 'user updated' do
        let(:user) do
          {
            email: 'Some email'
          }
        end

        run_test!
      end

      response '400', 'invalid attributes' do
        let(:user) do
          {
            email: nil
          }
        end

        run_test!
      end
    end

    delete 'Deletes User' do
      produces 'application/json'
      description 'Deletes specific user'

      response '204', 'user deleted' do
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
