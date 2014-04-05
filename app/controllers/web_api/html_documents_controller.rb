class WebApi::HtmlDocumentsController < WebApi::ApplicationController
  respond_to :json, :html

  def index
    query = Elastic::HtmlDocument::SearchQuery.new query: params[:q],
                                                   scope: params[:scope],
                                                   offset: params[:offset],
                                                   user: current_user
    documents = query.result
    render json: documents, root: :html_documents
  end

  def show
    query = Elastic::HtmlDocument::FindQuery.new params[:id]
    @document = query.result
    respond_with @document
  end
end
