require 'rails'
require 'mark_don/request_handler'
require 'mark_don/controller_helpers'

module MarkDon
  class Railtie < Rails::Railtie
    # Rails 8.1+ ships "text/markdown" as :md already.
    # We skip re-registration if it's present, and explicitly define format.markdown
    # on the Collector so that respond_to blocks can use it without hitting
    # method_missing (which recurses infinitely when the MIME symbol is :md but
    # the called method is :markdown).
    initializer 'mark_don.mime_type' do
      Mime::Type.register 'text/markdown', :markdown unless Mime[:md] || Mime[:markdown]

      unless ActionController::MimeResponds::Collector.method_defined?(:markdown)
        ActionController::MimeResponds::Collector.class_eval do
          def markdown(...)
            custom(Mime[:md] || Mime[:markdown], ...)
          end
        end
      end
    end

    # Intercepts any markdown request before respond_to runs. Switches the format to
    # :html so the action renders its HTML view normally, then converts the response.
    # Checks both :md (Rails 8.1+ symbol) and :markdown (custom registration).
    initializer 'mark_don.around_action' do
      ActiveSupport.on_load(:action_controller) do
        include MarkDon::RequestHandler
        around_action :mark_don_handle_markdown_request
      end
    end

    initializer 'mark_don.controller_helpers' do
      ActiveSupport.on_load(:action_controller) do
        include MarkDon::ControllerHelpers
      end
    end
  end
end
