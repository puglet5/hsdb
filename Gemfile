# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'active_record_extended', '~> 3.0'
gem 'active_storage-send_zip', '~> 0.3.4'
gem 'activestorage-validator', '~> 0.2.2'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'caxlsx', '~> 3.2' # .xlsx generation
gem 'caxlsx_rails', '~> 0.6.3'
gem 'cssbundling-rails', '~> 1.0'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'doorkeeper', '~> 5.5', '>= 5.5.4' # api oauth
gem 'dotenv-rails', '~> 2.8'
gem 'elasticsearch', '~> 7.13', '< 7.14'
gem 'elasticsearch-model', '~> 7.2'
gem 'elasticsearch-persistence', '~> 7.2'
gem 'elasticsearch-rails', '~> 7.2'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'image_processing', '~> 1.12', '>= 1.12.1'
gem 'jsbundling-rails', '~> 1.0'
gem 'ledermann-rails-settings', '~> 2.5' # user settings
gem 'logstasher', '~> 2.1' # generate logstash compatible rails logs
gem 'mini_magick', '~> 4.11' # image processing
gem 'pagy', '~> 5.10.1' # pagination
gem 'pg', '~> 1.4' # postgres
gem 'propshaft', '~> 0.6' # asset delivery
gem 'public_activity', '~> 2.0', '>= 2.0.2' # db activity tracking
gem 'puma', '>= 5.6.4'
gem 'pundit', '~> 2.1' # authorization / policies
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 7.0.4'
gem 'rails-i18n', '~> 7.0.4'
gem 'rails_semantic_logger', '~> 4.10'
gem 'ransack', '~> 3.2.1' # object-based searching
gem 'redis', '~> 5.0'
gem 'rolify', '~> 6.0' # user roles
gem 'rswag-api', '~> 2.5', '>= 2.5.1' # api testing and documentation
gem 'rswag-ui', '~> 2.5', '>= 2.5.1'
gem 'sidekiq', '~> 7.0' # background jobs
gem 'simple_form', '~> 5.1' # form helpers
gem 'stimulus-rails', '~> 1.1'
gem 'turbo-rails', '~> 1.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component', '~> 2.62'

gem 'client_side_validations', '~> 21.0'
gem 'client_side_validations-simple_form', '~> 15.0'

group :development do
  gem 'active_record_doctor', '~> 1.10'
  gem 'amazing_print', '~> 1.4'
  gem 'annotate', '~> 3.2' # db schema annotations for models and tests
  gem 'bullet', '~> 7.0', '>= 7.0.3' # detect ineffective db queries
  gem 'erb_lint', '~> 0.3.0'
  gem 'foreman', '~> 0.87.2'
  gem 'guard-livereload' # reload browser on file changes
  gem 'htmlbeautifier' # erb formatter
  gem 'immigrant' # generate db migrations
  gem 'letter_opener' # mail in development
  gem 'license_finder', '~> 7.0' # find dependencies' licenses
  gem 'rack-livereload'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'rails-erd' # generate er diagrams
  gem 'rubocop', '~> 1.35', '>= 1.35.1', require: false
  gem 'rubocop-performance', '~> 1.14', '>= 1.14.3', require: false
  gem 'rubocop-rails', '~> 2.15', '>= 2.15.2', require: false
  gem 'solargraph', '~> 0.44.2' # ruby language server
  gem 'solargraph-rails', '~> 1.0.1'
  gem 'web-console'
end

group :test do
  gem 'pundit-matchers', '~> 1.7' # policy matchers
  gem 'rails-controller-testing', '~> 1.0'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.1' # rails matchers for common tasks
  gem 'simplecov', '~> 0.21.2' # code coverage reporter
  gem 'webdrivers'
  gem 'webmock'
end

group :development, :test do
  gem 'better_errors', '~> 2.9'
  gem 'binding_of_caller', '~> 1.0' # for better_errors
  gem 'brakeman', '~> 5.2'
  gem 'bundler-audit', '~> 0.9.1'
  gem 'capybara'
  gem 'database_cleaner-active_record'
  gem 'database_consistency', '~> 1.1'
  gem 'debug', '>= 1.0.0'
  gem 'factory_bot_rails'
  gem 'faker', '>= 3'
  gem 'fuubar', '~> 2.5'
  gem 'listen', '~> 3.7'
  gem 'rspec-rails', '~> 6'
  gem 'rswag-specs', '~> 2.5', '>= 2.5.1'
end
