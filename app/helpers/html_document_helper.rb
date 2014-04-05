module HtmlDocumentHelper
  def html_document_content(document)
    html = Base64.decode64(document.content_in_base64)

    #img, a
    tags = %w[section article strong em b i p code pre tt samp kbd var sub sup dfn cite big small address
              hr br div span h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr acronym blockquote del ins]
    Readability::Document.new(html, tags: tags).content
  end
end
