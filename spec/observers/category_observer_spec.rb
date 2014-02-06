require 'spec_helper'

describe CategoryObserver do
  it 'save in percolator' do
    category = create :category

    repository = DocumentsPercolatorSearchRepository.new
    assert { repository.exists? category }
  end
end