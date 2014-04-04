class ExtractionService
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
      original_html: original_html,
    }
  end

private
  def title
    @title ||= page.title.strip
  end

  def description
    return @description if @description
    max_length = 160
    @description = page.search('/html/head/meta[@name="description"]/@content').first.try(:value) || ''

    return @description if @description.length > 0 && @description.length < max_length
    @description = sanitized_content.truncate(max_length, separator: /\s/)
  end

  def sanitized_content
    @sanitized_content ||= Readability::Document.new(original_html, tags: []).content
  end

  def keywords
    return @keywords if @keywords
    keywords = page.search('/html/head/meta[@name="keywords"]/@content').first.try(:value) || ''
    @keywords = keywords.split(',').map(&:strip)
  end

  def original_html
    @original_html ||= page.content
  end
end
