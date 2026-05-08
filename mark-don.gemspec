require_relative 'lib/mark_don/version'

Gem::Specification.new do |spec|
  spec.name    = 'mark-don'
  spec.version = MarkDon::VERSION
  spec.authors = ['Paul Lahana']
  spec.email   = ['paul.lahana@gmail.com']

  spec.summary     = 'Render Rails HTML views as Markdown'
  spec.description = 'A Rails gem that converts HTML views to Markdown on-the-fly via format.markdown in respond_to blocks.'
  spec.homepage    = 'https://github.com/paultursuru/mark-don'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.2'

  spec.files         = Dir['lib/**/*', '*.gemspec', 'Gemfile', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_dependency 'rails',            '>= 6.1'
  spec.add_dependency 'reverse_markdown', '~> 2.1'
  spec.add_dependency 'nokogiri',         '>= 1.13'

  spec.add_development_dependency 'rspec-rails', '~> 6.0'
  spec.add_development_dependency 'capybara',    '~> 3.0'
  spec.add_development_dependency 'simplecov',   '~> 0.22'
end
