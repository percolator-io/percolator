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

  sequence :text do
    <<-END
      In publishing and graphic design, lorem ipsum is a placeholder text commonly used to demonstrate the graphic
      elements of a document or visual presentation. By replacing the distraction of meaningful content with filler text
      of scrambled Latin it allows viewers to focus on graphical elements such as font, typography, and layout.
    END
  end

  sequence :page_attrs do
    {
        title: FactoryGirl.generate(:string),
        description: FactoryGirl.generate(:string),
        keywords: ['keyword', FactoryGirl.generate(:string)].join(','),
        body: FactoryGirl.generate(:text),
    }
  end
end
