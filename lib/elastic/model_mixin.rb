module Elastic::ModelMixin
  extend ActiveSupport::Concern

  included do
    include Virtus.model
    include ActiveModel::SerializerSupport
  end
end