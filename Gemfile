# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'rails', '~> 7.0.3'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.6.4'
# gem 'turbolinks', '~> 5' //loaded through webpack, see package.json
gem 'redis', '~> 4.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bullet'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'devise', '~> 4.8'
gem 'devise-i18n', '~> 1.10.1'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'graphicsmagick', '~> 1.0', '>= 1.0.6'
gem 'image_processing', '~> 1.12', '>= 1.12.1'
gem 'jquery-rails', '~> 4.4'
gem 'kaminari', '~> 1.2', '>= 1.2.1'
gem 'mini_magick', '~> 4.11'
gem 'public_activity'
gem 'pundit', '~> 2.1'
gem 'rails-i18n', '~> 7.0.3'
gem 'ransack', '~> 3.2.1'
gem 'rolify', '~> 6.0'
gem 'rubyzip', '~> 2'
gem 'simple_form', '~> 5.1'
gem 'textacular', '~> 5.5'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'sprockets-rails', '~> 3.4'
gem 'jsbundling-rails', '~> 1.0'
gem 'cssbundling-rails', '~> 1.0'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# gem 'stimulus_reflex', '~> 3.5.0.pre9'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 5.1.2'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'web-console', '>= 4.1.0'
  gem 'erd'
  gem 'faker', '~> 2.18'
  gem 'htmlbeautifier'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'rails-perftest'
  gem 'rubocop', '~> 1.31.0', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby-prof'
  gem 'spring'
  gem 'guard-livereload'
  gem 'rack-livereload'
end

group :test do
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

