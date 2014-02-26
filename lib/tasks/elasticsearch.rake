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
end
