module Elastic
  module HtmlDocument
    class SearchQuery < BaseQuery
      attr_reader :query_string, :offset, :scope

      # scope может быть nil, 'category_ID', или любой другой строкой
      def initialize(query_string, scope = nil, offset = nil)
        @query_string = query_string
        @scope = scope
        @offset = offset || 0
      end

      def result
        q = if query_string.present?
          query.deep_merge scope_filter
        else
          scope_filter
        end

        q.merge! query_options
        search q
      end

    private
      def query_options
        { from: offset }
      end

      def query
        {
          query: {
            simple_query_string: {
              query: query_string,
              fields: %w(title^2 description keywords content host),
            }
          }
        }
      end

      def scope_filter
        filter = case scope
          when /category_(\d+)/ then category_filter($1)
          else match_all_filter
        end
        {
          query: {
            constant_score: {
              filter: filter
            }
          }
        }
      end

      #TODO: избавиться от дублирования
      def category_filter(category_id)
        category = Category.find_by id: category_id
        {
          query: {
            query_string: {
              query: category.try(:query) || '',
              fields: %w(title description keywords host),
            }
          }
        }
      end

      def match_all_filter
        {
           match_all: {}
        }
      end
    end
  end
end
