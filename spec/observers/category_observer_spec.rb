require 'spec_helper'

describe CategoryObserver do
  it 'save in percolator' do
    category = create :category

    result = Elastic::DocumentsPercolator::ExistsQuery.new(category.id).result
    assert { result == true }
  end
end