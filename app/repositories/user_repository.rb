module UserRepository
  extend ActiveSupport::Concern

  included do
    has_many :select_category_selections, -> { with_kind(:selected) }, class_name: 'CategorySelection'
    has_many :excluded_category_selections, -> { with_kind(:excluded) }, class_name: 'CategorySelection'

    has_many :selected_categories, through: :select_category_selections, source: :category
    has_many :excluded_categories, through: :excluded_category_selections, source: :category

    scope :admin, -> { where(admin: true) }

    def selected_categories_with_descendants
      return [] if selected_categories.empty?
      descendants = Category.with_ancestor(*selected_categories)
      selected_categories | descendants
    end

    def excluded_categories_with_descendants
      return [] if excluded_categories.empty?
      descendants = Category.with_ancestor(*excluded_categories)
      excluded_categories | descendants
    end
  end
end
