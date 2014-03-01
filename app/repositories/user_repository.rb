module UserRepository
  extend ActiveSupport::Concern

  included do
    has_many :select_category_selection, -> { with_kind(:selected) }, class_name: 'CategorySelection'
    has_many :excluded_category_selection, -> { with_kind(:excluded) }, class_name: 'CategorySelection'

    has_many :selected_categories, through: :select_category_selection, source: :category
    has_many :excluded_categories, through: :excluded_category_selection, source: :category
  end
end
