module CategoriesHelper
  def categories_for_select
    @_categories_for_select ||= _categories_array_from_tree(Category.hash_tree)
  end

private
  def _category_name_for_select(name, depth)
    ['-' * depth, name].select(&:present?).join(' ')
  end

  def _categories_array_from_tree(tree, depth = 0)
    result = []
    tree.each do |node, children|
      result << [_category_name_for_select(node.name, depth), node.id]
      result += _categories_array_from_tree(children, depth + 1)
    end

    result
  end
end
