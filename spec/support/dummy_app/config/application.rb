require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

require 'mark_don'

module DummyApp
  class Application < Rails::Application
    config.root              = File.expand_path('..', __dir__)
    config.eager_load        = false
    config.logger            = Logger.new(nil)
    config.log_level         = :fatal
    config.secret_key_base   = 'dummy_secret_key_base_for_testing_only_do_not_use_in_production'
    config.cache_classes     = true

    # No database needed
    config.api_only = false
  end
end
