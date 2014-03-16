module HtmlPage
  class << self
    def render(attrs)
      path = fixture_file_path("page.html.haml")
      template = File.read(path)
      Haml::Engine.new(template).render(Object.new, attrs)
    end
  end
end
