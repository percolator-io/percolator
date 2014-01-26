module ElasticsearchSchema
  module DocumentsIndex
    class << self
      def mappings
        {
          html_document: {
            properties: {
              html: { type: :langdetect },
              url: { type: :string },
              host: { type: :string },
              title: { type: :string },
              description: { type: :string },
              keywords: { type: :string },
            }
          }
        }
      end
    end
  end
end