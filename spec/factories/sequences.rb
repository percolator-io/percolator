FactoryGirl.define do
  sequence :integer do |n|
    n
  end

  sequence :string do |n|
    "string-#{n}"
  end

  sequence :email do |n|
    "email_#{n}@mail.com"
  end

  sequence :name do |n|
    "name-#{n}"
  end

  sequence :host do |n|
    "domain-#{n}.ru"
  end

  sequence :page_attrs do
    {
        title: FactoryGirl.generate(:string),
        description: FactoryGirl.generate(:string),
        keywords: ['keyword', FactoryGirl.generate(:string)].join(','),
        body: FactoryGirl.generate(:string),
    }
  end
end
