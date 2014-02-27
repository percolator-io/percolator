module CategoriesHelper
  def categories_for_select
    categories_array_from_tree Category.hash_tree
  end

private
  def categories_array_from_tree(tree, depth = 0)
    result = []
    tree.each do |node, children|
      result << ["#{'-' * depth} #{node.name}", node.id]
      result += categories_array_from_tree(children, depth + 1)
    end

    result
  end
end
