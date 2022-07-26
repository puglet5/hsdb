# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
require 'bootsnap'
env = ENV['RAILS_ENV'] || 'development'
Bootsnap.setup(
  cache_dir: 'tmp/cache', # Path to your cache
  development_mode: env == 'development', # Current working environment, e.g. RACK_ENV, RAILS_ENV, etc
  load_path_cache: true, # Optimize the LOAD_PATH with a cache
  compile_cache_iseq: true,                 # Compile Ruby code into ISeq cache, breaks coverage reporting.
  compile_cache_yaml: true                  # Compile YAML into a cache
)
