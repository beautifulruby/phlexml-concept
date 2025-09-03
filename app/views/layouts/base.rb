class Views::Layouts::Base < Views::Base
  def initialize(title: "PhlexML")
    @title = title
  end

  def view_template
    html do
      head do
        title { @title }
        meta charset: "utf-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1"
      end

      body do
        yield
      end
    end
  end
end
