module Elastic
  module HtmlDocument

    class Operation < BaseOperation
      class << self
        def index
          :documents
        end

        def type
          :html_document
        end
      end
    end

  end
end
