# Phlex `.rb` Views in Rails

This demo shows how to write Rails views directly in **Ruby** using
[Phlex](https://github.com/phlex-ruby/phlex) instead of ERB or Haml.
Instead of mixing Ruby into HTML, the view file *is* a Ruby class that renders HTML.

## The Idea

Rails normally renders `.html.erb` (ERB), `.html.haml` (Haml), etc.
Each extension maps to a **template handler** that turns the file’s source into Ruby code.

Here we register a new handler for `.rb` files. It takes the raw Ruby source,
wraps it in a tiny `Phlex::HTML` subclass, and lets Rails render it.

That means a view file like:

```ruby
# app/views/application/index.rb

h1 { "Hello, world!" }
p { "This is a Phlex view written in plain Ruby." }
```

is equivalent to writing:

```ruby
class MyView < Views::Base
  def view_template
    h1 { "Hello, world!" }
    p { "This is a Phlex view written in plain Ruby." }
  end
end

MyView.new.render_in(view_context)
```

## How It Works

The custom handler (`config/initializers/phlexml.rb`) looks like this:

```ruby
# frozen_string_literal: true

module Phlex::Markup
  class Handler
    def self.call(template, source = nil)
      src = source || template.source

      <<~RUBY
        # Define an anonymous subclass of Phlex::HTML
        __phlex_class__ = Class.new(::Views::Base) do
          def view_template
            #{src}
          end
        end

        # Instantiate and render it
        __phlex_class__.new.render_in(self).to_s
      RUBY
    end
  end
end

ActionView::Template.register_template_handler :rb, Phlex::Markup::Handler
```

When Rails compiles the view:

1. The handler generates a Ruby string that defines an **anonymous subclass**
   of `Views::Base` (a `Phlex::HTML` base class you define for your app).
2. The view source (`h1 { … }`, etc.) becomes the body of `view_template`.
3. The handler instantiates the class and calls `render_in(self)` with the Rails view context.
4. Rails caches the compiled method, so in production there’s no runtime penalty.

## Why?

- **All Ruby, no ERB.** No `<%= %>` — just method calls.
- **Full power of Phlex.** Components, layouts, helpers — all work as normal.
- **Explicit.** Each `.rb` view is compiled into a real Ruby class.

## Development vs Production

- In development, Rails recompiles templates when the file changes.
- In production, templates are compiled once and cached.
- Because the handler uses `Class.new`, a fresh anonymous class is created each compile.
  If you want to reuse a stable constant per file, you can constantize with the
  template path hash. (Not required for production.)

## Example

```ruby
# app/views/posts/show.rb

h1 { @post.title }
p  { @post.body }

aside do
  a(href: posts_path) { "Back to posts" }
end
```

This produces:

```html
<h1>My Post Title</h1>
<p>The post body…</p>
<aside>
  <a href="/posts">Back to posts</a>
</aside>
```

## Next Steps

- Wire `.html.rb` instead of bare `.rb` for proper content negotiation.
- Explore layouts by having `Views::Base` provide a wrapper `view_template`.
- Consider constantizing template classes for better debugging.
