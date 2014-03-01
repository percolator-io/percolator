FactoryGirl.define do
  factory :category_selection do
    category
    user
    kind :selected
  end
end
