# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.session_store :cache_store

  config.after_initialize do
    Bullet.enable = false
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'PublicActivity::Activity', association: :owner
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'Artwork', association: :images_attachments
    Bullet.add_safelist type: :unused_eager_loading, class_name: 'ActiveStorage::Attachment', association: :blob
  end

  # config.devServer.injectClient = false

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.server_timer = true

  config.assets.quiet = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :redis_cache_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  config.action_mailer.preview_path = Rails.root.join('spec/mailers/previews')

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::FileUpdateChecker

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.hosts << '127.0.0.1'

  config.serve_static_assets = false

  config.action_view.image_loading = 'lazy'

  # setup sidekiq logger to work with semantic logger
  config.semantic_logger.add_appender(io: $stdout, formatter: :color) if Sidekiq.server?

  # semantic logger config
  config.rails_semantic_logger.semantic = true
  config.rails_semantic_logger.started    = false
  config.rails_semantic_logger.processing = true
  config.rails_semantic_logger.rendered   = false
  config.log_level = :info
  config.rails_semantic_logger.quiet_assets = true
  config.rails_semantic_logger.ap_options = { multiline: true }
  config.rails_semantic_logger.format = :color
  config.log_tags = nil

  config.hotwire_livereload.reload_method = :turbo_stream

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  config.require_master_key = true
end