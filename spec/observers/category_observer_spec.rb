require 'spec_helper'

describe CategoryObserver do
  it 'save in percolator' do
    category = create :category

    result = Elastic::DocumentsPercolator::ExistsQuery.new(category).result
    assert { result == true }
  end

  it 'delete from percolator' do
    category = create :category
    category.destroy

    result = Elastic::DocumentsPercolator::ExistsQuery.new(category).result
    assert { result == false }
  end
end