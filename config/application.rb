# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require_relative '../lib/logger_utils'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StorytellerApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # Doc on ActiveSupport::TimeZone: https://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
    config.time_zone = 'Eastern Time (US & Canada)'

    config.extra_load_paths = %w[
      lib/tasks
      lib/templates
    ].map { |path| Rails.root.join(path).to_s }
    config.autoload_paths += config.extra_load_paths
    config.eager_load_paths += config.extra_load_paths

    # # Stackdriver Google Cloud Logging: https://github.com/googleapis/google-cloud-ruby/blob/main/stackdriver/INSTRUMENTATION_CONFIGURATION.md
    # StackdriverUtils.setup if StackdriverUtils.enabled?

    config.log_tags = { request_id: :request_id, ip: :remote_ip }

    # Configure session storage (required to use Sidekiq web UI): https://guides.rubyonrails.org/api_app.html#using-session-middlewares
    config.session_store :cookie_store, key: '_storysprout_session'
    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    # Flipper mount options
    config.flipper.mount_options = {}

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Configure admin emails
    config.admin_emails = config_for(:admins)[:emails]

    # Configure admin remote IP addresses
    config.admin_remote_ips = config_for(:admins)[:ip_addresses]

    # Configure allowed hosts. See doc https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
    config.hosts += config_for(:allowed_hosts)

    # Docs on ActiveJob queue adapters: https://guides.rubyonrails.org/active_job_basics.html#backends
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
