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
          query.deep_merge filter
        else
          filter.merge sort
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
            filtered: {
              query: {
                simple_query_string: {
                  query: query_string,
                  fields: %w(title^2 description keywords sanitized_content.sanitized_content host),
                }
              }
            }
          }
        }
      end

      def filter
        filters = case scope
        when /category_(\d+)/ then [category_filter(Category.find_by id: $1), verified_content_filter]
        when 'stars' then [stars_filter]
        when 'selected' then [selected_filter, verified_content_filter]
        else [verified_content_filter]  # or match_all_filter
        end
        filters << have_content_filter
        {
          query: {
            filtered: {
              filter: {
                and: filters
              }
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
        return { not: match_all_filter } if should.empty? && must_not.empty? #TODO: fix me

        {
          bool: {
            should: should,
            must_not: must_not,
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
        { match_all: {} }
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

      def have_content_filter
        {
          exists: {
            field: %w[url title]
          }
        }
      end

      def verified_content_filter
        {
          and: [wot_filter(:trustworthiness, 40, 15), wot_filter(:child_safety, 40, 15),  white_list]
        }
      end

      # see http://mywot.com
      def wot_filter(category_name, reputation_level, confidence_level)
        raise 'unknown category_name' if %w[trustworthiness child_safety].exclude? category_name.to_s
        {
          or: [
            {
              nested: {
                path: category_name,
                filter: {
                  or: [
                    {
                      and: [
                        { range: { "#{category_name}.reputation" => { gte: reputation_level } } },
                        { range: { "#{category_name}.confidence" => { gte: confidence_level } } }
                      ]
                    },
                    # выбираем все с недостаточным уровнем уверенности в корректности репутации
                    { range: { "#{category_name}.confidence" => { lt: confidence_level } } },
                    { missing: { field: %W[#{category_name}.reputation #{category_name}.confidence] } }
                  ]
                }
              }
            },
            # uncomment when closed https://github.com/elasticsearch/elasticsearch/issues/4192
            #{ missing: { field: "#{category_name}" } },
          ]
        }
      end

      def white_list
        { term: { blacklists: false } }
      end
    end

  end
end
