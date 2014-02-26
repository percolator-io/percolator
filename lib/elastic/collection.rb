class Elastic::Collection
  include Enumerable

  attr_accessor :total_count

  delegate :each, to: :@search_results

  def initialize(search_results, total_count)
    @search_results = search_results
    @total_count = total_count
  end

  def active_model_serializer
    Elastic::CollectionSerializer
  end
end
