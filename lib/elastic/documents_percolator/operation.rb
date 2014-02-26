module Elastic
  module DocumentsPercolator

    class Operation < BaseOperation
      class << self
        def index
          :documents
        end

        def type
          :'.percolator'
        end
      end
    end

  end
end
