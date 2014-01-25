namespace :elasticsearch do
  task remove_indicies: :environment do
    ElasticsearchSchema.remove_indicies
  end

  task create_indices: :environment do
    ElasticsearchSchema.create_indices
  end

  task put_mappings: :environment do
    ElasticsearchSchema.put_mappings
  end

  task recreate_indices: %i(remove_indicies create_indices)
  task reset: %i(recreate_indices put_mappings)
end
