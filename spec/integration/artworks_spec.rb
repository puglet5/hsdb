# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Artworks API' do
  path '/api/v1/artworks' do
    get 'Lists artworks' do
      tags 'Artworks'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'ok' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/artworks/{id}' do
    get 'Retrieves an artwork' do
      tags 'Artworks'
      produces 'application/json', 'application/xml'
      parameter name: 'id', in: :path, type: :string
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'ok' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 description: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
                 user_id: { type: :integer },
                 slug: { type: :string },
                 status: { type: :string },
                 metadata: { type: :object }
               },
               required: %w[id title description]

        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:artwork) { create(:artwork) }
        let(:id) { artwork.id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:artwork) { create(:artwork) }
        let(:id) { artwork.id }
        run_test!
      end

      response '404', 'not found' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
