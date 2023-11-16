# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'sidekiq/testing'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'
require 'devise'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Sidekiq::Testing.fake!

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include ActiveModelSerializers::Test::Schema
  config.include ActiveModelSerializers::Test::Serializer

  # HSDB
  config.before(:suite) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.clean
  end

  config.before(:all) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner[:active_record, db: :primary]
    DatabaseCleaner.clean
  end

  # RSDB
  config.before(:suite) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.clean
  end

  config.before(:all) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner[:active_record, db: :rsdb]
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :system
  config.include Warden::Test::Helpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include RequestSpecHelper, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
