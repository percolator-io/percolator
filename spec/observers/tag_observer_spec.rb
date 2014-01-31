require 'spec_helper'

describe TagObserver do
  it 'save in percolator' do
    tag = create :tag

    repository = DocumentsPercolatorSearchRepository.new
    assert { repository.exists? tag }
  end
end