class UpdateHtmlDocumentWorker
  include Sidekiq::Worker

  def perform(normalized_uri_components)
    normalized_uri_components.symbolize_keys!
    uri = Addressable::URI.new normalized_uri_components

    attrs = {
        url: uri.to_s,
        host: uri.host,
    }

    a = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end

    #TODO: может проставить заголовки Accept, что бы page имел класс Mechanize::Page
    page = a.get(uri)
    return unless page.kind_of? Mechanize::Page

    reputation_attrs = Reputation.new(uri.host).get
    attrs.merge! reputation_attrs

    extracted_attrs = ExtractionService.extract(page)
    attrs.merge! extracted_attrs

    id = IdGenerator.from_normalized_uri uri
    Elastic::HtmlDocument::UpdateCommand.new(id, attrs).perform
  end
end