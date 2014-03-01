class WebApi::HtmlDocumentsController < WebApi::ApplicationController
  def index
    query = Elastic::HtmlDocument::SearchQuery.new query: params[:q],
                                                   scope: params[:scope],
                                                   offset: params[:offset],
                                                   user: current_user
    documents = query.result
    render json: documents, root: :html_documents
  end
end
