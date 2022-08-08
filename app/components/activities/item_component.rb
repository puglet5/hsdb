# frozen_string_literal: true

class Activities::ItemComponent < ViewComponent::Base
  def initialize(activity:)
    @activity = activity
  end

end
