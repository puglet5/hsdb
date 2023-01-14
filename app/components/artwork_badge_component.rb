# frozen_string_literal: true

class ArtworkBadgeComponent < ViewComponent::Base
  attr_reader :status

  def initialize(status: '', cls: '')
    @status = status
    @cls = cls
  end

  STATUSES = {
    'active' => 'text-sky-800 bg-sky-100',
    'draft' => 'text-yellow-800 bg-yellow-100',
    'archived' => 'text-gray-800 bg-gray-100'
  }.freeze

  def color(status)
    STATUSES[status]
  end
end
