class Api::V1::StarsController < ApplicationController
  def create
    url = star_params[:url]
    StarCreatorService.create(url)

    head :ok
  end

  private
  def star_params
    params.require(:star).permit(:url)
  end
end
