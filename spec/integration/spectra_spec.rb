# frozen_string_literal: true

require 'swagger_helper'

RSpec.fdescribe 'Spectra API' do
  path '/api/v1/spectra' do
    get 'Lists spectra' do
      tags 'Spectra'
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

  path '/api/v1/spectra/{id}' do
    get 'Retrieves an spectrum' do
      tags 'Spectra'
      produces 'application/json', 'application/xml'
      parameter name: 'id', in: :path, type: :string
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'ok' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 user_id: { type: :integer },
                 slug: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
                 metadata: { type: :object },
                 processing_status: { type: :string }
               },
               required: %w[id title user_id metadata processing_status]

        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:spectrum) { create(:spectrum) }
        let(:id) { spectrum.id }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:spectrum) { create(:spectrum) }
        let(:id) { spectrum.id }
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
