class Web::CategoriesController < Web::ApplicationController
  def index
    @category_tree = Category.hash_tree
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      redirect_to categories_path
    else
      render action: :new
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    if @category.update category_params
      redirect_to categories_path
    else
      render action: :edit
    end
  end

  def destroy
    @category = Category.find params[:id]
    @category.destroy
    redirect_to categories_path
  end

private
  def category_params
    params.require(:category).permit(:name, :parent_id, :keywords)
  end
end