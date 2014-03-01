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
        q = if query_string.present?
          query.deep_merge scope_filter
        else
          scope_filter.merge sort
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
        when 'stars' then stars_filter
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
        else first_star_sort
        end
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

      def stars_filter
        return match_all_filter if user.guest?
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
        return last_star_sort if user.guest?
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
