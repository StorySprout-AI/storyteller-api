require_relative "boot"

require "rails/all"

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
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

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

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
