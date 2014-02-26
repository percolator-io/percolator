class CategoryStoreWorker
  include Sidekiq::Worker

  def perform(id)
    category = Category.find(id)
    Elastic::DocumentsPercolator::StoreCommand.new(category).perform
  end
end