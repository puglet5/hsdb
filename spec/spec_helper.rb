# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each, type: :request) do
    host! '127.0.0.1:3000'
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/config/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
  end
end
