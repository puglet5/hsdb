# frozen_string_literal: true

class SampleCategoryBadgeComponent < ViewComponent::Base
  attr_reader :category

  def initialize(category: '', cls: '')
    @category = category
    @cls = cls
  end

  CATEGORIES = {
    'pigments' => 'text-gray-700 bg-gradient-to-r from-sky-200 via-amber-200 to-secondary-200',
    'ceramics' => 'text-amber-800 bg-amber-100',
    'other' => 'text-sky-800 bg-sky-100',
    'not_set' => 'text-gray-800 bg-gray-100'
  }.freeze

  def color(category)
    CATEGORIES[category]
  end
end
