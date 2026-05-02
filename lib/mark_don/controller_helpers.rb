module MarkDon
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      # Declares that this controller supports markdown responses.
      # With no arguments, this is a semantic label only — the global around_action
      # already handles all markdown requests.
      # Pass `only:` or `except:` to restrict markdown conversion to specific actions.
      def markdown_render(only: nil, except: nil)
        return unless only || except

        skip_around_action :mark_don_handle_markdown_request
        around_action(only: only, except: except) do |controller, action|
          if MarkDon::MARKDOWN_FORMAT_SYMBOLS.include?(controller.request.format.symbol)
            controller.request.format = :html
            action.call
            if controller.performed? && controller.response.successful?
              html     = Array(controller.response_body).join
              markdown = MarkDon::Converter.convert(html)
              controller.response_body          = markdown
              controller.response.content_type  = Mime[:markdown].to_s
            end
          else
            action.call
          end
        end
      end
    end
  end
end
