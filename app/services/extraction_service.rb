module ExtractionService
  class << self
    def extract(page)
      {
          title:  page.title,
          description: description(page),
          keywords: keywords(page),
          content: content(page),
      }
    end

  private
    def description(page)
      max_length = 160
      descr = page.search('/html/head/meta[@name="description"]/@content').first.try(:value) || ''

      return descr if descr.length > 0 && descr.length < max_length
      content(page).truncate(max_length, separator: /\s/)
    end

    def content(page)
      document = Readability::Document.new(page.content)
      sanitizer = HTML::FullSanitizer.new
      sanitized_content = sanitizer.sanitize(document.content)
      sanitized_content.gsub!(/\s+/, ' ' )
      sanitized_content.strip!
      sanitized_content
    end

    def keywords(page)
      keywords = page.search('/html/head/meta[@name="keywords"]/@content').first.try(:value) || ''
      keywords.split(',').map(&:strip)
    end
  end
end
