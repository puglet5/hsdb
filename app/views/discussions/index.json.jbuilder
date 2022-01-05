# frozen_string_literal: true

json.array! @discussions, partial: 'discussions/discussion', as: :discussion
