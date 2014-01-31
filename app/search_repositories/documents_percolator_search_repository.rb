class DocumentsPercolatorSearchRepository < BaseSearchRepository
  index :documents
  type '.percolator'

  def exists?(tag)
    POOL.with do |client|
      client.exists address.merge id: tag.id
    end
  end

  def store(tag)
    params = address.merge id: tag.id, body: tag_to_percolator(tag)

    POOL.with do |client|
      client.index params
    end
  end

private
  def address
    { index: self.class.index, type: self.class.type }
  end

  # TODO: вынести
  def tag_to_percolator(tag)
    {
        query: {
            match: {
                _all: tag.name
            }
        }
    }
  end
end