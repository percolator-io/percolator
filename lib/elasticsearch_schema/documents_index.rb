module ElasticsearchSchema
  module DocumentsIndex
    class << self
      def settings
        # возможно стоит посмотреть внимательее на
        # http://gibrown.wordpress.com/2013/05/01/three-principles-for-multilingal-indexing-in-elasticsearch/

        {
          analysis: {
            analyzer: {
              ru: {
                  type: :russian,
              },
              en: {
                  type: :english,
              },
            }
          }
        }


        #{
        #  analysis: {
        #    filter: {
        #      en_stop_filter: {
        #        type: "stop",
        #        stopwords: ["_english_"]
        #      },
        #      en_stem_filter: {
        #        type: "stemmer",
        #        name: "minimal_english"
        #      },
        #      ru_stop_filter: {
        #        type: "stop",
        #        stopwords: ["_russian_"]
        #      },
        #      ru_stem_filter: {
        #        type: "stemmer",
        #        name: "light_russian"
        #      },
        #    },
        #
        #    analyzer: {
        #      ru: {
        #        type: :snowball,
        #        tokenizer: :icu_tokenizer,
        #        filter: %i(icu_folding icu_normalizer ru_stop_filter ru_stem_filter),
        #        char_filter: %i(html_strip)
        #      },
        #      en: {
        #        type: :custom,
        #        tokenizer: :icu_tokenizer,
        #        filter: %i(icu_folding icu_normalizer en_stop_filter en_stem_filter),
        #        char_filter: %i(html_strip)
        #      },
        #      unknown: {
        #        type: :custom,
        #        tokenizer: :icu_tokenizer,
        #        filter: %i(icu_folding icu_normalizer),
        #        char_filter:%i(html_strip)
        #      },
        #    }
        #  }
        #}
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