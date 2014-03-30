class StarCreatorWorker
  include Sidekiq::Worker

  def perform(normalized_uri_components, user_id)
    normalized_uri_components.symbolize_keys!
    uri = Addressable::URI.new normalized_uri_components
    id = IdGenerator.from_normalized_uri uri
    Elastic::HtmlDocument::AddStarCommand.new(id, user_id).perform
  end
end