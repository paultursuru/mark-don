require 'rails_helper'

RSpec.describe 'Markdown format', type: :request do
  describe 'format.markdown in respond_to (per-action)' do
    it 'returns markdown when Accept: text/markdown' do
      get '/rooms/1', headers: { 'Accept' => 'text/markdown' }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/markdown')
      expect(response.body).to include('# Room 1')
      expect(response.body).to include('**great**')
      expect(response.body).to include('[nice view](/view)')
      expect(response.body).to include('WiFi included')
    end

    it 'returns html for a normal request' do
      get '/rooms/1'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')
      expect(response.body).to include('<h1>')
    end

    it 'returns markdown when using .markdown format suffix' do
      get '/rooms/1.markdown'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/markdown')
      expect(response.body).to include('# Room 1')
    end
  end

  describe 'markdown_render macro (controller-level)' do
    it 'returns markdown without format.markdown in respond_to' do
      get '/articles/42', headers: { 'Accept' => 'text/markdown' }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/markdown')
      expect(response.body).to include('# Article 42')
      expect(response.body).to include('_interesting_')
    end

    it 'returns html when not requesting markdown' do
      get '/articles/42'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')
      expect(response.body).to include('<h1>')
    end
  end
end
