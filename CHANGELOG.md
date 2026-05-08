# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2026-05-08

### Added
- `data-markdown-ignore` boolean attribute to exclude any HTML element (and its children) from Markdown output

## [0.1.1] - 2026-04-30

### Fixed
- Register `.md` file extension with MIME type so URL-based format detection works (e.g. `/articles/1.md`)

## [0.1.0] - 2026-04-29

### Added
- Initial release
- Convert any Rails HTML view to Markdown on-the-fly via `format.markdown` in `respond_to` blocks
- `markdown_render` controller macro with `only:` / `except:` options
- Support for `Accept: text/markdown` header and `.md` URL suffix
- Rails 6.1+ and Ruby 3.0+ compatibility

[Unreleased]: https://github.com/paultursuru/mark-don/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/paultursuru/mark-don/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/paultursuru/mark-don/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/paultursuru/mark-don/releases/tag/v0.1.0
