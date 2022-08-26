# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  config.before :each do
    stub_request(:any, /localhost:9200/).to_return(status: 200)
  end
end
