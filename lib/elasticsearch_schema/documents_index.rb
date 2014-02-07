module ElasticsearchSchema
  module DocumentsIndex
    class << self
      def settings
        # возможно стоит посмотреть внимательее на
        # http://gibrown.wordpress.com/2013/05/01/three-principles-for-multilingal-indexing-in-elasticsearch/

        with_standard_analyzer = %w(unknown af ar bg bn cs da de el es et fa fi fr gu he hi hr hu id it ja kn ko lt lv
                                    mk ml mr ne nl no pa pl pt ro sk sl so sq sv sw ta te th tl tr uk ur vi zh-cn zh-tw)

        analyzer = with_standard_analyzer.inject({}) do |memo, lang|
          memo.merge lang => { type: :standard }
        end

        analyzer.merge!(
          'ru' => { type: :russian },
          'en' => { type: :english },
        )

        {
          analysis: {
            analyzer: analyzer
          }
        }
      end

      def mappings
        {
          html_document: {
            _analyzer: {
              path: 'content.lang'
            },

            properties: {
              content: { type: :langdetect },
              url: { type: :string },
              host: { type: :string, index: :not_analyzed },
              title: { type: :string },
              description: { type: :string },
              keywords: { type: :string, index: :not_analyzed },
            }
          }
        }
      end
    end
  end
end