require 'spec_helper'
require 'mark_don/converter'

RSpec.describe MarkDon::Converter do
  describe '.convert' do
    it 'converts headings' do
      expect(described_class.convert('<h1>Title</h1>')).to eq('# Title')
    end

    it 'converts bold text' do
      expect(described_class.convert('<p><strong>bold</strong></p>')).to eq('**bold**')
    end

    it 'converts italic text' do
      expect(described_class.convert('<p><em>italic</em></p>')).to eq('_italic_')
    end

    it 'converts links' do
      result = described_class.convert('<a href="/path">click here</a>')
      expect(result).to eq('[click here](/path)')
    end

    it 'converts images' do
      result = described_class.convert('<img src="/img.png" alt="photo">')
      expect(result).to eq('![photo](/img.png)')
    end

    it 'converts unordered lists' do
      html = '<ul><li>WiFi included</li><li>Breakfast at 8am</li></ul>'
      result = described_class.convert(html)
      expect(result).to include('- WiFi included')
      expect(result).to include('- Breakfast at 8am')
    end

    it 'converts ordered lists' do
      result = described_class.convert('<ol><li>First</li><li>Second</li></ol>')
      expect(result).to include('1. First')
      expect(result).to include('2. Second')
    end

    it 'strips script tags and their content' do
      html = '<p>Hello</p><script>alert("xss")</script>'
      result = described_class.convert(html)
      expect(result).not_to include('alert')
      expect(result).not_to include('<script>')
    end

    it 'strips style tags and their content' do
      html = '<style>body { color: red; }</style><p>Hello</p>'
      result = described_class.convert(html)
      expect(result).not_to include('color: red')
      expect(result).not_to include('<style>')
    end

    it 'extracts only body content from a full HTML document' do
      html = <<~HTML
        <html>
          <head><title>Page</title><meta charset="utf-8"></head>
          <body><h1>Content</h1></body>
        </html>
      HTML
      result = described_class.convert(html)
      expect(result).to eq('# Content')
    end

    it 'matches the CLAUDE.md example exactly' do
      html = <<~HTML
        <h1>My Room</h1>
        <p>This is a <strong>great</strong> room with a <a href="/view">nice view</a>.</p>
        <ul>
          <li>WiFi included</li>
          <li>Breakfast at 8am</li>
        </ul>
      HTML
      result = described_class.convert(html)
      expect(result).to include('# My Room')
      expect(result).to include('**great**')
      expect(result).to include('[nice view](/view)')
      expect(result).to include('WiFi included')
      expect(result).to include('Breakfast at 8am')
    end
  end
end
