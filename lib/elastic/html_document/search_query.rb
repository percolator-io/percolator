module Elastic
  module HtmlDocument
    class SearchQuery < BaseQuery
      attr_reader :query_string, :offset, :scope, :user

      # scope может быть nil, 'category_ID', или любой другой строкой
      def initialize(query: '', scope: nil, offset: 0, user: User::Guest.new)
        @query_string = query
        @scope = scope
        @offset = offset
        @user = user
      end

      def result
        result_q = {}
        result_q.merge! query_options

        q = if query_string.present?
          query.deep_merge scope_filter
        else
          scope_filter.merge sort
        end
        result_q.merge! q

        search result_q
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
              fields: %w(title^2 description keywords sanitized_content.sanitized_content host),
            }
          }
        }
      end

      def scope_filter
        filter = case scope
        when /category_(\d+)/ then category_filter(Category.find_by id: $1)
        when 'stars' then stars_filter
        when 'selected' then selected_filter
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

      def sort
        case scope
        when 'stars' then user_star_sort
        when 'selected' then first_star_sort
        else last_star_sort
        end
      end

      def category_filter(category)
        Elastic::Shared::CategoryQuery.query category
      end

      def selected_filter
        # should a->b, must_not b, может быть стоит оптимизировать
        should = user.selected_categories_with_descendants.map{ |c| category_filter c }
        must_not = user.excluded_categories_with_descendants.map{ |c| category_filter c }
        {
          bool: {
            should: should,
            must_not: must_not
          }
        }
      end

      def stars_filter
        {
          nested: {
            path: 'stars',
            filter: {
              term: {
                  'stars.user_id' => user.id
              }
            }
          }
        }
      end

      def match_all_filter
        {
           match_all: {}
        }
      end

      def first_star_sort
        {
          sort: [
            {
              'stars.created_at' => {
                mode: :min,
                order: :desc,
              }
            }
          ]
        }
      end

      def last_star_sort
        {
          sort: [
            {
              'stars.created_at' => {
                mode: :max,
                order: :desc,
              }
            }
          ]
        }
      end

      def user_star_sort
        {
          sort: [
            {
              'stars.created_at' => {
                mode: :max,
                order: :desc,
                nested_filter: {
                  term: { 'stars.user_id' => user.id }
                }
              }
            }
          ]
        }
      end
    end
  end
end
