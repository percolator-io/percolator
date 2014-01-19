module ElasticsearchSchema
  module DocumentsIndex
    class << self
      def mappings
        {
            html_document: {
              properties: {
                  html: { type: :string }
              }
            }
        }
      end
    end
  end
end