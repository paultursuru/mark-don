require 'reverse_markdown'
require 'nokogiri'

module MarkDon
  class Converter
    STRIP_TAGS = %w[script style meta link].freeze

    def self.convert(html)
      doc = Nokogiri::HTML(html)
      STRIP_TAGS.each { |tag| doc.css(tag).remove }

      body = doc.at('body') || doc
      ReverseMarkdown.convert(body.inner_html, unknown_tags: :bypass, github_flavored: true).strip
    end
  end
end
