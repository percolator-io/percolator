FactoryGirl.define do
  sequence :n, aliases: %i(integer uid) do |n|
    n
  end

  sequence :string, aliases: %i(name external_id) do |n|
    "string-#{n}"
  end

  sequence :email do |n|
    "email_#{n}@mail.com"
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
        content: FactoryGirl.generate(:text),
    }
  end

  sequence :github_auth do |n|
    auth = OmniAuth::AuthHash.new
    auth.uid = n.to_s
    auth.info!.name = FactoryGirl.generate :string
    auth
  end
end
