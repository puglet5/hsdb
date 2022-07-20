# frozen_string_literal: true

class RsdbRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :rsdb, reading: :rsdb_replica }
end
