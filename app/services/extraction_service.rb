class ExtractionService
  extend MethodDecorators

  attr_reader :page, :sanitizer

  def initialize(page)
    @page = page
    @sanitizer = HTML::FullSanitizer.new
  end

  def extract
    {
      title:  title,
      description: description,
      keywords: keywords,
      sanitized_content: sanitized_content,
      content_in_base64: content_in_base64,
    }
  end

private
  +MethodDecorators::Memoize
  def title
    page.title.to_s.strip
  end

  +MethodDecorators::Memoize
  def description
    max_length = 160
    description = page.search('/html/head/meta[@name="description"]/@content').first.try(:value).to_s
    return description if description.length > 0 && description.length < max_length

    sanitized_content.truncate(max_length, separator: /\s/)
  end

  +MethodDecorators::Memoize
  def sanitized_content
    Readability::Document.new(content, tags: []).content
  end

  +MethodDecorators::Memoize
  def keywords
    keywords = page.search('/html/head/meta[@name="keywords"]/@content').first.try(:value).to_s
    keywords.split(',').map(&:strip)
  end

  +MethodDecorators::Memoize
  def content
    page.content.to_s
  end

  +MethodDecorators::Memoize
  def content_in_base64
    Base64.encode64(content)
  end
end
