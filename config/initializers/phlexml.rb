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
