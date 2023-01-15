# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Samples API' do
  path '/api/v1/samples' do
    get 'Lists samples' do
      tags 'Samples'
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

  path '/api/v1/samples/{id}' do
    get 'Retrieves a sample' do
      tags 'Samples'
      produces 'application/json', 'application/xml'
      parameter name: 'id', in: :path, type: :string
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'ok' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 sku: { type: :string },
                 metadata: { type: :object },
                 processing_status: { type: :integer },
                 category: { type: :string },
                 origin: { type: :string },
                 owner: { type: :string },
                 compound: { type: :string },
                 survey_date: { type: :string },
                 spectra_count: { type: :integer },
                 documents_count: { type: :integer },
                 images_count: { type: :integer },
                 user: { type: :object }
               },
               required: %w[sample]

        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:sample) { create(:sample) }
        let(:id) { sample.id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:sample) { create(:sample) }
        let(:id) { sample.id }
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

  path '/api/v1/samples' do
    post 'Creates a sample' do
      tags 'Samples'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :sample, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: %w[title]
      }

      response '200', 'sample created' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:sample) { build(:sample, user: user) }

        run_test!
      end

      response '400', 'bad request' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:sample) { nil }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:sample) { Sample.new(title: nil) }

        run_test!
      end
    end
  end
end
