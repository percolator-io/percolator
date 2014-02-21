module ElasticsearchSchema
  module DocumentsIndex
    class << self
      def settings
        # возможно стоит посмотреть внимательее на
        # http://gibrown.wordpress.com/2013/05/01/three-principles-for-multilingal-indexing-in-elasticsearch

        {
          analysis: {
            filter: {
              en_stop_filter: {
                type: :stop,
                stopwords: %w(_english_)
              },
              en_stem_filter: {
                type: 'stemmer',
                name: 'minimal_english'
              },
              ru_stop_filter: {
                type: 'stop',
                stopwords: %w(_russian_)
              },
              ru_stem_filter: {
                type: 'stemmer',
                name: 'light_russian'
              },
            },
            analyzer: {
              default: {
                type: :custom,
                tokenizer: 'icu_tokenizer',
                filter: %w(lowercase icu_folding icu_normalizer ru_stop_filter ru_stem_filter en_stop_filter en_stem_filter),
              },
              keywords_analyzer: {
                  type: :custom,
                  tokenizer: 'icu_tokenizer',
                  filter: %w(lowercase icu_folding icu_normalizer)
              }
            }
          }
        }
      end

      def mappings
        {
          html_document: {
            properties: {
              title: { type: :string },
              description: { type: :string },
              keywords: { type: :string, analyzer: :keywords_analyzer },
              content: { type: :string },
              url: { type: :string, index: :not_analyzed },
              host: { type: :string, index: :not_analyzed },
              stars: {
                  type: :nested,
                  properties: {
                    user_id: { type: :integer },
                    created_at: { type: :date },
                  },
              },
            }
          }
        }
      end
    end
  end
end