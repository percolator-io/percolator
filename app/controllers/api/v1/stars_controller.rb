class Api::V1::StarsController < ApplicationController
  def create
    url = star_params[:url]
    creator = StarCreatorService.new(url)
    creator.create

    head :ok
  end

  private
  def star_params
    params.require(:star).permit(:url)
  end
end
