class Web::TagsController < ApplicationController
  def index
    @tag_tree = Tag.hash_tree
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new tag_params
    if @tag.save
      redirect_to edit_tag_path(@tag)
    else
      render action: :new
    end
  end

  def edit
    @tag = Tag.find params[:id]
  end

  def update
    @tag = Tag.find params[:id]
    if @tag.update tag_params
      redirect_to edit_tag_path(@tag)
    else
      render action: :edit
    end
  end

  def destroy
    @tag = Tag.find params[:id]
    @tag.destroy
    redirect_to tags_path
  end

private
  def tag_params
    params.require(:tag).permit(:name)
  end
end