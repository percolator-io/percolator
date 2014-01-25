module HtmlPage
  class << self
    def render(attrs)
      template = File.read("#{Rails.root}/spec/files/page.html.haml")
      Haml::Engine.new(template).render(Object.new, attrs)
    end
  end
end
