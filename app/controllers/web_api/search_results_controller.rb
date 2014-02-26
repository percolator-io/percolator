class WebApi::SearchResultsController < WebApi::ApplicationController
  def index
    query = Elastic::HtmlDocument::WideSearchQuery.new(params[:q], params[:offset])
    documents = query.result
    render json: documents, root: :html_documents
  end
end
