class TagObserver < ActiveRecord::Observer
  def after_commit(tag)
    if tag.persisted?
      after_commit_on_save(tag)
    else
      after_commit_on_destroy(tag)
    end
  end

  def after_commit_on_save(tag)
    repository = DocumentsPercolatorSearchRepository.new
    repository.store tag
  end

  def after_commit_on_destroy(tag)

  end
end