class CategoryObserver < ActiveRecord::Observer
  def after_commit(object)
    if object.persisted?
      after_commit_on_create_or_update(object)
    else
      after_commit_on_destroy(object)
    end
  end

  def after_commit_on_create_or_update(category)
    Elastic::DocumentsPercolator::StoreCommand.new(category).perform
  end

  def after_commit_on_destroy(category)
    Elastic::DocumentsPercolator::DeleteCommand.new(category).perform
  end
end
