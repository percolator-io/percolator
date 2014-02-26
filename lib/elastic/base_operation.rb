module Elastic
  class BaseOperation
  private
    def address
      { index: self.class.index, type: self.class.type }
    end
  end
end