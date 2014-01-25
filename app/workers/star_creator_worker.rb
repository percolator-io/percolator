class StarCreatorWorker
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
    a.get(uri) do |page|
      attrs[:html] = page.content
      attrs[:title] = page.title
      attrs[:description] = page.search('/html/head/meta[@name="description"]/@content').first.try(:value)
      attrs[:keywords] = page.search('/html/head/meta[@name="keywords"]/@content').first.try(:value).try(:split, ',')
    end

    id = IdGenerator.from_normalized_uri uri
    repository = HtmlDocumentSearchRepository.new
    repository.store id, attrs
  end
end