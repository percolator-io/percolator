module ExtractionService
  class << self
    def extract(page)
      attrs = {}
      attrs[:title] = page.title
      attrs[:description] = page.search('/html/head/meta[@name="description"]/@content').first.try(:value)
      attrs[:keywords] = page.search('/html/head/meta[@name="keywords"]/@content').first.try(:value).try(:split, ',')

      document = Readability::Document.new(page.content)
      sanitizer = HTML::FullSanitizer.new
      sanitized_content = sanitizer.sanitize(document.content)
      sanitized_content.gsub!(/\s+/, ' ' )
      sanitized_content.strip!

      attrs[:content] = sanitized_content

      attrs
    end
  end
end