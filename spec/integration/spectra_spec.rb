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
    get 'Retrieves a spectrum' do
      tags 'Spectra'
      produces 'application/json', 'application/xml'
      parameter name: 'id', in: :path, type: :string
      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'ok' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 format: { type: :string },
                 status: { type: :string },
                 category: { type: :string },
                 range: { type: :string },
                 metadata: { type: :object },
                 file_url: { type: :string },
                 filename: { type: :string },
                 sample: { type: :object }
               },
               required: %w[spectrum]

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

  path '/api/v1/spectra' do
    post 'Creates a spectrum' do
      tags 'Spectra'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :spectrum, in: :body, schema: {
        type: :object,
        properties: {
          sample_id: { type: :integer }
        },
        required: %w[sample_id]
      }

      response '200', 'spectrum created' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:sample) { build(:sample, user: user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:spectrum) { create(:spectrum) }

        run_test!
      end

      response '400', 'bad request' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:sample) { build(:sample, user: user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:spectrum) { nil }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:application) { FactoryBot.create(:application) }
        let(:user)        { FactoryBot.create(:user) }
        let(:sample) { build(:sample, user: user) }
        let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }
        let(:Authorization) { "Bearer #{token.token}" }
        let(:spectrum) { Spectrum.new(sample_id: nil) }

        run_test!
      end
    end
  end
end
