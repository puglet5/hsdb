# frozen_string_literal: true

require 'rack-mini-profiler'
Rack::MiniProfiler.config.position = 'bottom-left'

module RackTurboExtension
  def get_profile_script(*args, **kargs)
    super(*args, **kargs).gsub('></script>', ' data-turbo-permanent="true"></script>')
  end
end

module Rack
  class MiniProfiler
    prepend RackTurboExtension
  end
end
