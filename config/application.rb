# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module HSDB
  class Application < Rails::Application
    config.load_defaults 7.0

    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :en

    config.time_zone = 'Moscow'

    config.active_job.queue_adapter = :sidekiq

    # mailers config
    config.action_mailer.deliver_later_queue_name = nil # defaults to "mailers"
    config.action_mailbox.queues.routing    = nil       # defaults to "action_mailbox_routing"

    # active storage config
    config.active_storage.queues.mirror     = nil # defaults to "active_storage_mirror"
    config.active_storage.track_variants = true # used to eager load image variants

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.component_specs false
    end

    # image processing config
    Rails.application.config.active_storage.variant_processor = :mini_magick
    Rails.application.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer
    Rails.application.config.active_storage.analyzers.append ActiveStorage::Analyzer::ImageAnalyzer::Vips

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post put delete options]
      end
    end

    config.to_prepare do
      Doorkeeper::ApplicationsController.layout 'application'
    end
    # config.to_prepare do
    #   Doorkeeper::ApplicationController.include Internationalization
    # end
  end
end

module JSON
  def self.is_json?(json)
    case json
    when String
      true if JSON.parse(json)
    when Hash
      true if JSON.parse(JSON.generate(json))
    end
  rescue JSON::ParserError
    false
  end
end

# fixes rspec error with psych 4 and ruby 3.1
module YAML
  class << self
    alias load unsafe_load if YAML.respond_to? :unsafe_load
  end
end
