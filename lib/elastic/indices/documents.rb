module Elastic
  module Indices

    module Documents
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
                  filter: %w(lowercase icu_folding icu_normalizer ru_stop_filter russian_morphology en_stop_filter english_morphology),
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
              _timestamp: { enabled: true, store: true },
              properties: {
                title: { type: :string },
                description: { type: :string },
                keywords: { type: :string, analyzer: :keywords_analyzer },
                sanitized_content: { type: :langdetect },
                url: { type: :string, index: :not_analyzed },
                host: { type: :string, index: :not_analyzed },
                original_html: { type: :string, index: :not_analyzed },
                updated_at: { type: :date },
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
end