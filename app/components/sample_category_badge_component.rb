# frozen_string_literal: true

class SampleCategoryBadgeComponent < ViewComponent::Base
  attr_reader :category

  def initialize(category: '', cls: '')
    @category = category
    @cls = cls
  end

  CATEGORIES = {
    'pigments' => 'text-sky-800 bg-sky-100',
    'ceramics' => 'text-amber-800 bg-amber-100',
    'other' => 'text-lime-800 bg-lime-100',
    'not_set' => 'text-gray-800 bg-gray-100'
  }.freeze

  def color(category)
    CATEGORIES[category]
  end
end
