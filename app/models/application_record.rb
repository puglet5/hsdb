# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include PublicActivity::Model
  tracked
  self.abstract_class = true
end
