class Api::V1::StarsController < Api::ApplicationController
  def create
    url = star_params[:url]
    StarCreatorService.create(url, current_user)

    #TODO: разобраться
    response.headers['Access-Control-Allow-Origin'] = '*'
    head :ok
  end

  private
  def star_params
    params.require(:star).permit(:url)
  end
end
