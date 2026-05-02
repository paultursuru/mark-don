# mark-don

Serve any Rails HTML view as Markdown — no templates to write.

When a client requests `text/markdown` (via `Accept` header or `.md` extension), mark-don intercepts the normal HTML render, converts the output on the fly, and returns it with `Content-Type: text/markdown`. Your existing `.html.erb` views are reused as-is.

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

The gem converts the `<body>` content of the rendered HTML to GitHub Flavored Markdown using [reverse_markdown](https://github.com/xijo/reverse_markdown) under the hood. `<script>`, `<style>`, `<meta>`, and `<link>` tags are stripped. Inline styles and unknown elements are dropped; their text content is preserved.

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

## Requirements

- Ruby >= 3.0
- Rails >= 6.1

## License

MIT
