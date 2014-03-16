module Elastic::Shared::CategoryQuery
  class << self
    def query(category)
      {
        query: {
          simple_query_string: {
            query: category.try(:query) || '',
            fields: %w(title description keywords host),
          }
        }
      }
    end
  end
end