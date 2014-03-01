class WebApi::HtmlDocumentsController < WebApi::ApplicationController
  def index
    query = Elastic::HtmlDocument::SearchQuery.new(params[:q], params[:scope], params[:offset])
    documents = query.result
    render json: documents, root: :html_documents
  end
end
