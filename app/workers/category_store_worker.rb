class CategoryStoreWorker
  include Sidekiq::Worker

  def perform(id)
    category = Category.find(id)
    repository = DocumentsPercolatorSearchRepository.new
    repository.store category
  end
end