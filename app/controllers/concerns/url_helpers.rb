module UrlHelpers
  extend ActiveSupport::Concern

  included do
    %w(github).each do |provider|
      method_name = "auth_#{provider}_cpath"
      define_method method_name do
        "/auth/#{provider}"
      end
      helper_method method_name
    end
  end
end