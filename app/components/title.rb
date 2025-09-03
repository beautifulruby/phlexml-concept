# frozen_string_literal: true

class Components::Title < Components::Base
  def view_template
    yield self if block_given?
  end

  def around_template
    super do
      hgroup(class: "space-y-2") { yield }
    end
  end

  def title(&)
    h1(class: "text-3xl font-bold underline") { yield }
  end

  def subtitle(&)
    h2(class: "text-xl font-semibold") { yield }
  end
end
