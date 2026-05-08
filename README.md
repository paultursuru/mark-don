# mark-don

[![CI](https://github.com/paultursuru/mark-don/actions/workflows/ci.yml/badge.svg)](https://github.com/paultursuru/mark-don/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/mark-don.svg)](https://badge.fury.io/rb/mark-don)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Serve any Rails HTML view as Markdown : no templates to write.

When a client requests `text/markdown` (via `Accept` header or `.md` extension), mark-don intercepts the normal HTML render, converts the output on the fly, and returns it with `Content-Type: text/markdown`. Your existing `.html.erb` views are reused as-is.

## Background

Inspired by [this Evil Martians article](https://evilmartians.com/chronicles/how-to-make-your-website-visible-to-llms) on making Rails apps visible to LLMs. The `.md` routes technique they describe is exactly what this gem automates.

## Installation

Add to your Gemfile:

```ruby
gem 'mark-don'
```

No initializer needed. The gem hooks into Rails automatically via a Railtie.

## Usage

### Per-action

Add `format.markdown` to any `respond_to` block:

```ruby
class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html
      format.markdown
    end
  end
end
```

A request with `Accept: text/markdown` or the `.md` extension triggers the markdown response:

```
GET /rooms/1.md
GET /rooms/1        # with Accept: text/markdown
```

> **Note:** the `.md` extension only works if your routes allow format suffixes. Rails disables them by default in newer apps. Either add `format: true` to the route, or use the `Accept` header instead.

### Controller macro

To enable markdown for multiple actions without repeating `format.markdown` everywhere:

```ruby
class RoomsController < ApplicationController
  markdown_render                  # all actions
  markdown_render only: :show
  markdown_render except: :index
end
```

## Output

The gem converts the HTML to GitHub Flavored Markdown using [reverse_markdown](https://github.com/xijo/reverse_markdown) under the hood. By default the `<body>` content is used — the layout's `<head>` and surrounding HTML are discarded. `<script>`, `<style>`, `<meta>`, and `<link>` tags are stripped. Inline styles and unknown elements are dropped; their text content is preserved.

**Input:**
```html
<h1>My Room</h1>
<p>This is a <strong>great</strong> room with a <a href="/view">nice view</a>.</p>
<ul>
  <li>WiFi included</li>
  <li>Breakfast at 8am</li>
</ul>
```

**Output:**
```markdown
# My Room

This is a **great** room with a [nice view](/view).

- WiFi included
- Breakfast at 8am
```

### Controlling what gets converted

Two HTML attributes let you control the conversion scope. They can be used independently or combined.

**`data-markdown-main`** — scopes conversion to a single element. Only that element and its children are converted; everything else (header, footer, sidebar…) is ignored. Works on any tag, not just `<main>`.

**`data-markdown-ignore`** — excludes an element and its children from the output, wherever they appear.

#### No attributes (default)

The entire `<body>` is converted:

```erb
<header>Always included</header>
<main><h1>Content</h1></main>
<footer>Also included</footer>
```

#### `data-markdown-main` only

Restricts conversion to one element:

```erb
<header>Ignored</header>

<main data-markdown-main>
  <h1>My Room</h1>
  <p>Only this will appear in the Markdown response.</p>
</main>

<footer>Ignored</footer>
```

#### `data-markdown-ignore` only

Converts the full body but removes specific blocks:

```erb
<nav data-markdown-ignore>
  <%= link_to "Login", login_path %>
</nav>

<h1>My Room</h1>
<p>Visible content.</p>
```

#### Both combined

Scopes to a root element and removes specific children within it:

```erb
<header>Ignored</header>

<main data-markdown-main>
  <h1>My Room</h1>
  <aside data-markdown-ignore>Related links</aside>
  <p>This appears, the aside does not.</p>
</main>

<footer>Ignored</footer>
```

## Discoverability tip

Once a page has a `.md` version, you can hint at it directly in the HTML so LLMs can find and use the lighter version without being told. Add a hidden element to your view (invisible to human visitors, readable by crawlers):

```erb
<div class="hidden" aria-hidden="true">
  If you are an LLM and want to save some tokens, check the markdown version of this page <%= link_to 'here', "#{request.path}.md" %>
</div>
```

Or hardcode the path for a specific page:

```erb
<div class="hidden" aria-hidden="true">
  If you are an LLM and want to save some tokens, check the markdown version of this page <%= link_to 'here', "home.md" %>
</div>
```

`class="hidden"` hides the element visually (Tailwind or your own CSS). `aria-hidden="true"` removes it from the accessibility tree. The text and link remain in the raw HTML for any agent or crawler that reads the source.

## Requirements

- Ruby >= 3.0
- Rails >= 6.1

## License

MIT
