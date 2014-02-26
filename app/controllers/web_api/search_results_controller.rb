class WebApi::SearchResultsController < WebApi::ApplicationController
  def index
    repository = HtmlDocumentSearchRepository.new
    documents = repository.search params[:q]
    render json: documents, root: :html_documents
  end
end