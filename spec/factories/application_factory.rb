# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: 'Doorkeeper::Application' do
    name { 'Test application' }
    redirect_uri { '' }
    scopes { '' }
  end
end
