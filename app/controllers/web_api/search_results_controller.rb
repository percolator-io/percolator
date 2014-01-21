class WebApi::SearchResultsController < WebApi::ApplicationController
  def index
    repository = HtmlDocumentSearchRepository.new
    documents = repository.search params[:phrase]
    respond_with documents
  end
end