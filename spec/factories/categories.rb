FactoryGirl.define do
  factory :category do
    name
    keywords { (0...5).map{ generate :string }.join(',') }
  end
end