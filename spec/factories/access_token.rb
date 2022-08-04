# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    application factory: :application
    resource_owner_id factory: :user
    expires_in { 2.hours }
    scopes { '' }
  end
end
