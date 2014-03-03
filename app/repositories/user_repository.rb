module UserRepository
  extend ActiveSupport::Concern

  included do
    has_many :select_category_selections, -> { with_kind(:selected) }, class_name: 'CategorySelection'
    has_many :excluded_category_selections, -> { with_kind(:excluded) }, class_name: 'CategorySelection'

    has_many :selected_categories, through: :select_category_selections, source: :category
    has_many :excluded_categories, through: :excluded_category_selections, source: :category

    def selected_categories_with_descendants
      descendants = Category.with_ancestor(*selected_categories)
      selected_categories | descendants
    end

    def excluded_categories_with_descendants
      descendants = Category.with_ancestor(*excluded_categories)
      excluded_categories | descendants
    end
  end
end
