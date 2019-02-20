require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Surfnotify
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # use resque as active job queue adapter
    config.active_job.queue_adapter = :resque

    # log to STDOUT for docker
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = [:subdomain, :uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    Raven.configure do |config|
      config.async = lambda { |event| SentryJob.perform_later(event) }
      config.dsn = ENV['SENTRY_DSN']
      config.open_timeout = 10
      config.environments = %w[production]
      config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    end
  end
end
