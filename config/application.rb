# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
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

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ITMOHsdb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :en
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Moscow'
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.deliver_later_queue_name = nil # defaults to "mailers"
    config.action_mailbox.queues.routing    = nil       # defaults to "action_mailbox_routing"
    config.active_storage.queues.mirror     = nil       # defaults to "active_storage_mirror"
  end
end

module JSON
  def self.is_json?(foo)
    return false unless foo.is_a?(String)

    JSON.parse(foo).all?
  rescue JSON::ParserError
    false
  end
end
