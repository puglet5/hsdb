# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

gem 'active_model_serializers', '~> 0.10.13'
gem 'active_record_extended', '~> 3.0'
gem 'active_storage-send_zip', '~> 0.3.4'
gem 'activestorage-validator', '~> 0.3'
gem 'acts_as_favoritor', '~> 6.0'
gem 'ar_transaction_changes', '~> 1.1'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'caxlsx', '~> 4.0' # .xlsx generation
gem 'caxlsx_rails', '~> 0.6.3'
gem 'cssbundling-rails', '~> 1.0'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'doorkeeper', '~> 5.5', '>= 5.5.4' # api oauth
gem 'dotenv-rails', '~> 3.1'
gem 'faraday', '~> 2.7'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'has_scope', '~> 0.8.0'
gem 'image_processing', '~> 1.12', '>= 1.12.1'
gem 'jsbundling-rails', '~> 1.0'
gem 'ledermann-rails-settings', '~> 2.5' # user settings
gem 'loaf', '~> 0.10.0'
gem 'mini_magick', '~> 4.11' # image processing
gem 'pagy', '~> 6.0' # pagination
gem 'pg', '~> 1.4' # postgres
gem 'propshaft', '~> 0.6' # asset delivery
gem 'puma', '~> 6.4'
gem 'pundit', '~> 2.1' # authorization / policies
gem 'rack-cors', '~> 2.0'
gem 'rack-mini-profiler', '~> 3.0'
gem 'rails', '~> 7.1'
gem 'rails-i18n', '~> 7.0.4'
gem 'ransack', '~> 4.1' # object-based searching
gem 'rchardet', '~> 1.8'
gem 'redis', '~> 5.0'
gem 'redis-client', '~> 0.14'
gem 'rolify', '~> 6.0' # user roles
gem 'rswag-api', '~> 2.5', '>= 2.5.1' # api testing and documentation
gem 'rswag-ui', '~> 2.5', '>= 2.5.1'
gem 'sidekiq', '~> 7.1' # background jobs
gem 'simple_form', '~> 5.1' # form helpers
gem 'stimulus-rails', '~> 1.1'
gem 'turbo-rails', '~> 1.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component', '~> 3.9'

gem 'client_side_validations', '~> 22.0'
gem 'client_side_validations-simple_form', '~> 16.0'

group :development do
  gem 'active_record_doctor', '~> 1.10'
  gem 'amazing_print', '~> 1.4'
  gem 'annotate', '~> 3.2' # db schema annotations for models and tests
  gem 'bullet', '~> 7.0', '>= 7.0.3' # detect ineffective db queries
  gem 'erb_lint', '~> 0.4'
  gem 'foreman', '~> 0.88'
  gem 'hotwire-livereload', '~> 1.2'
  gem 'htmlbeautifier' # erb formatter
  gem 'license_finder', '~> 7.0' # find dependencies' licenses
  gem 'rails-erd' # generate er diagrams
  gem 'rubocop', '~> 1.35', '>= 1.35.1', require: false
  gem 'rubocop-performance', '~> 1.14', '>= 1.14.3', require: false
  gem 'rubocop-rails', '~> 2.15', '>= 2.15.2', require: false
  gem 'web-console'
end

group :test do
  gem 'pundit-matchers', '~> 3.1' # policy matchers
  gem 'rails-controller-testing', '~> 1.0'
  gem 'shoulda-matchers', '~> 6.0' # rails matchers for common tasks
  gem 'simplecov', '~> 0.22' # code coverage reporter
end

group :development, :test do
  gem 'better_errors', '~> 2.10', '>= 2.10.1'
  gem 'binding_of_caller', '~> 1.0' # for better_errors
  gem 'brakeman', '~> 6.0'
  gem 'bundler-audit', '~> 0.9.1'
  gem 'database_cleaner-active_record'
  gem 'database_consistency', '~> 1.1'
  gem 'debug', '>= 1.0.0'
  gem 'factory_bot_rails', ' ~> 6.2'
  gem 'faker', '>= 3'
  gem 'fuubar', '~> 2.5'
  gem 'listen', '~> 3.7'
  gem 'rspec-rails', '~> 6'
  gem 'rswag-specs', '~> 2.5', '>= 2.5.1'
end

gem 'capistrano', '~> 3.17'
gem 'capistrano3-puma', '6.0.0.beta.1'
gem 'capistrano-bundler', '~> 2.1'
gem 'capistrano-git-with-submodules', '~> 2.0'
gem 'capistrano-rails', '~> 1.6'
gem 'capistrano-rails-console', '~> 2.3'
gem 'capistrano-rvm', '~> 0.1.2'
