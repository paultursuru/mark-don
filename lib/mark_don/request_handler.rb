module MarkDon
  MARKDOWN_FORMAT_SYMBOLS = %i[markdown md].freeze

  module RequestHandler
    def mark_don_handle_markdown_request(&action)
      if MarkDon::MARKDOWN_FORMAT_SYMBOLS.include?(request.format.symbol)
        request.format = :html
        action.call
        if performed? && response.successful?
          html     = Array(response_body).join
          markdown = MarkDon::Converter.convert(html)
          self.response_body    = markdown
          response.content_type = 'text/markdown'
        end
      else
        action.call
      end
    end
  end
end
