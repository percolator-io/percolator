namespace :elasticsearch do
  task remove_indicies: :environment do
    Elastic::Indices.remove
  end

  task create_indices: :environment do
    Elastic::Indices.create
  end

  task put_mappings: :environment do
    Elastic::Indices.put_mappings
  end

  task recreate_indices: %i(remove_indicies create_indices)
  task reset: %i(recreate_indices put_mappings)

  task reindex_categories: :environment do
    Category.find_each do |category|
      Elastic::DocumentsPercolator::StoreCommand.new(category).perform
    end
  end
end
