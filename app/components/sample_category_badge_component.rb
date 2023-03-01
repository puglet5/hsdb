# frozen_string_literal: true

class SampleCategoryBadgeComponent < ViewComponent::Base
  attr_reader :category

  def initialize(category: '', cls: '')
    @category = category
    @cls = cls
  end

  CATEGORIES = {
    'pigments' => 'text-sky-800 bg-sky-100 dark:border dark:border-sky-300 dark:bg-zinc-800 dark:text-sky-300',
    'ceramics' => 'text-amber-800 bg-amber-100 dark:border dark:border-amber-300 dark:bg-zinc-800 dark:text-amber-300',
    'other' => 'text-lime-800 bg-lime-100 dark:border dark:border-lime-300 dark:bg-zinc-800 dark:text-lime-300',
    'not_set' => 'text-gray-700 bg-gray-100 dark:border-zinc-300 dark:bg-zinc-800 dark:text-gray-300 dark:border'
  }.freeze

  def color(category)
    CATEGORIES[category]
  end
end
