class StarCreatorWorker
  include Sidekiq::Worker

  def perform(normalized_uri_components)
    normalized_uri_components.symbolize_keys!
    uri = Addressable::URI.new normalized_uri_components

    response = Net::HTTP.get_response(uri)
    #TODO: check status
    raise "Status: #{response.code}" if response.code != '200'

    doc = Nokogiri::HTML response.body

    attrs = {
        title: doc.xpath('/html/head/title').first.try(:content),
        description: doc.xpath('/html/head/meta[@name="description"]/@content').first.try(:value),
        keywords: doc.xpath('/html/head/meta[@name="keywords"]/@content').first.try(:value).try(:split, ','),
        url: uri.to_s,
        host: uri.host,
        html: response,
    }

    id = IdGenerator.from_normalized_uri uri
    repository = HtmlDocumentSearchRepository.new
    repository.store id, attrs
  end
end