# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# extended support for postgres (used for jsonb queries)
gem 'active_record_extended', '~> 3.0'

gem 'active_storage-send_zip', '~> 0.3.4'
gem 'activestorage-validator', '~> 0.2.2'
gem 'bootsnap', '>= 1.4.4', require: false

# .xlsx generation
gem 'caxlsx', '~> 3.2'
gem 'caxlsx_rails', '~> 0.6.3'

# JS and CSS bundling for esbuild
gem 'cssbundling-rails', '~> 1.0'
gem 'jsbundling-rails', '~> 1.0'

gem 'devise', '~> 4.8', '>= 4.8.1'

# OAuth 2 provider for API
gem 'doorkeeper', '~> 5.5', '>= 5.5.4'

gem 'dotenv-rails'

# elasticsearch
# main gem pinned to < 7.14 to use with elasticsearch-oss docker images
gem 'elasticsearch', '< 7.14'
gem 'elasticsearch-model', '~> 7.2'
gem 'elasticsearch-persistence', '~> 7.2'
gem 'elasticsearch-rails', '~> 7.2'

gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'image_processing', '~> 1.12', '>= 1.12.1'

# user settings
gem 'ledermann-rails-settings', '~> 2.5'

# generate logstash compatible logs
gem 'logstasher', '~> 2.1'

# image processing
gem 'mini_magick', '~> 4.11'

# pagination
gem 'pagy', '~> 5.10.1'

# postgres
gem 'pg', '~> 1.4'

# asset delivery
gem 'propshaft', '~> 0.6'

# db activity tracking
gem 'public_activity', '~> 2.0', '>= 2.0.2'

gem 'puma', '>= 5.6.4'

# authorization / policies
gem 'pundit', '~> 2.1'

gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 7.0.3'
gem 'rails-i18n', '~> 7.0.3'
gem 'rails_performance', '~> 1.0'
gem 'rails_semantic_logger', '~> 4.10'

# search
gem 'ransack', '~> 3.2.1'

gem 'redis', '4.7.1'

# user roles
gem 'rolify', '~> 6.0'

# api testing and documentation
gem 'rswag-api', '~> 2.5', '>= 2.5.1'

gem 'rswag-ui', '~> 2.5', '>= 2.5.1'

# background jobs
gem 'sidekiq', '~> 6.5', '>= 6.5.1'

# form helpers
gem 'simple_form', '~> 5.1'

gem 'stimulus-rails', '~> 1.1'
gem 'turbo-rails', '~> 1.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component', '~> 2.62'

group :development do
  gem 'active_record_doctor', '~> 1.10'
  gem 'amazing_print', '~> 1.4'

  # db schema annotations for models and tests
  gem 'annotate', '~> 3.2'

  # detect uneffective db queries
  gem 'bullet'
  gem 'foreman', '~> 0.87.2'

  # reload browser on file changes
  gem 'guard-livereload'
  gem 'rack-livereload'

  # erb formatter
  gem 'htmlbeautifier'

  # generate db migrations
  gem 'immigrant'

  # mail in development
  gem 'letter_opener'

  # find dependencies' licenses
  gem 'license_finder', '~> 7.0'

  gem 'rack-mini-profiler', '~> 3.0'

  # generate er diagrams
  gem 'rails-erd'

  gem 'rubocop', '~> 1.32', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false

  # ruby language server
  gem 'solargraph'
  gem 'solargraph-rails'

  gem 'web-console'
end

group :test do
  # policy matchers
  gem 'pundit-matchers', '~> 1.7'

  gem 'rails-controller-testing', '~> 1.0'
  gem 'selenium-webdriver'

  # rails matchers for common tasks
  gem 'shoulda-matchers', '~> 5.1'

  # code coverage reporter
  gem 'simplecov', '~> 0.21.2'

  gem 'webdrivers'
  gem 'webmock'
end

group :development, :test do

  # better errors
  gem 'better_errors', '~> 2.9'
  gem 'binding_of_caller', '~> 1.0'

  gem 'brakeman', '~> 5.2'
  gem 'bundler-audit', '~> 0.9.1'
  gem 'capybara'
  gem 'database_cleaner-active_record'
  gem 'database_consistency', '~> 1.1'
  gem 'debug', '>= 1.0.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'listen', '~> 3.7'
  gem 'rspec-rails', '~> 5.1.2'
  gem 'rswag-specs'
end
