class Views::Layouts::Application < Views::Layouts::Base
  def initialize(subtitle: nil, **)
    super(**)
    @subtitle = subtitle
  end

  def view_template
    super do
      Title {
        it.title { @title }
        it.subtitle { @subtitle }
      }
      main do
        yield
      end
    end
  end
end
