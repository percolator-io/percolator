class Api::V1::StarsController < ApplicationController
  def create
    url = star_params[:url]
    StarCreatorService.create(url)

    #TODO: разобраться
    response.headers['Access-Control-Allow-Origin'] = '*'
    head :ok
  end

  private
  def star_params
    params.require(:star).permit(:url)
  end
end
