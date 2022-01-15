# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', github: 'rails/webpacker', branch: 'master'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# gem "bulma-rails", "~> 0.9.1"
# gem 'bootstrap', '~> 5.0.1'
gem 'cancancan', '~> 3.3'
gem 'coderay', '~> 1.1', '>= 1.1.3'
gem 'devise', '~> 4.8'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'graphicsmagick', '~> 1.0', '>= 1.0.6'
gem 'gravatar_image_tag', '~> 1.2'
gem 'image_processing', '~> 1.12', '>= 1.12.1'
gem 'jquery-rails', '~> 4.4'
gem 'kaminari', '~> 1.2', '>= 1.2.1'
gem 'mini_magick', '~> 4.11'
gem 'petergate', '~> 2.0', '>= 2.0.1'
gem 'ransack', '~> 2.4', '>= 2.4.2'
gem 'redcarpet', '~> 3.5', '>= 3.5.1'
gem 'rolify', '~> 6.0'
gem 'simple_form', '~> 5.1'
gem 'materialize-sass', github: 'mkhairi/materialize-sass'
gem 'rubyzip', '~> 2'
gem 'caxlsx'
gem 'caxlsx_rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'erd'
  gem 'faker', '~> 2.18'
  gem 'htmlbeautifier'
  gem 'rails-erd'
  gem 'rails-perftest'
  gem 'rubocop', '~> 1.24', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby-prof'
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
