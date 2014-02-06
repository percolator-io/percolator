class DocumentsPercolatorSearchRepository < BaseSearchRepository
  index :documents
  type '.percolator'

  def exists?(category)
    POOL.with do |client|
      client.exists address.merge id: category.id
    end
  end

  def store(category)
    params = address.merge id: category.id, body: category_to_percolator(category)

    POOL.with do |client|
      client.index params
    end
  end

private
  def address
    { index: self.class.index, type: self.class.type }
  end

  # TODO: вынести
  def category_to_percolator(category)
    {
        query: {
            match: {
                _all: category.name
            }
        }
    }
  end
end