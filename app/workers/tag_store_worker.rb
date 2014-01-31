class TagStoreWorker
  include Sidekiq::Worker

  def perform(tag_id)
    tag = Tag.find(tag_id)
    repository = DocumentsPercolatorSearchRepository.new
    repository.store tag
  end
end