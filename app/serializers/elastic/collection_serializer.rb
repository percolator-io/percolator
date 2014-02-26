class Elastic::CollectionSerializer < ActiveModel::ArraySerializer
  def initialize(object, options={})
    params = {
      meta: {
        total_count: object.total_count,
      }
    }
    params.merge! options
    super(object, params)
  end
end
