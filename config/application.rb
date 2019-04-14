require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Embeds
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.assets.enabled = true
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/users/sessions/present', :headers => :any, :methods => [:get]
      end
    end

    config.default_image = "asdghyiulpfy"
    config.default_profile_image = "v1508457686/default_profile_gmtwcg.png"
    config.rate = 6000
    config.commission = 0.30
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
