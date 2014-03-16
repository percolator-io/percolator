require 'open-uri'

class CategoriesDeployWorker
  include Sidekiq::Worker

  #TODO: fix me
  def perform
    content = open "https://raw.github.com/percolator-io/categories/master/data/categories.yml"

    collection = PercolatorCategories::Collection.from_yaml content

    ActiveRecord::Base.transaction do
      import collection.roots
    end
  end

  def import(external_categories)
    external_categories.each do |external|
      category = Category.find_or_initialize_by external_id: external.id
      category.name = external.name
      category.query = external.query

      parent = Category.find_by external_id: external.parent.id if external.parent
      category.parent = parent

      #TODO: сохратять только изменившиеся
      category.save!

      import external.subcategories
    end
  end
end
