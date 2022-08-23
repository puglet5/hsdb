# frozen_string_literal: true

Ransack.configure do |config|
  config.search_key = :query
  config.add_predicate 'jcont', arel_predicate: 'contains', formatter: proc { |v| JSON.parse(v) }
end
