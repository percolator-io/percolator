FactoryGirl.define do
  factory :category do
    name
    tags { (0...5).map{ generate :string }.join(',') }
  end
end