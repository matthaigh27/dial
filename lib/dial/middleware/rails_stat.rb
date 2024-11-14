# frozen_string_literal: true

module Dial
  module RailsStat
    private

    def server_timing headers
      timing = if ::ActionDispatch.const_defined? "Constants::SERVER_TIMING"
        headers[::ActionDispatch::Constants::SERVER_TIMING]
      else
        headers["Server-Timing"]
      end
      (timing || "").split(", ").to_h do |pair|
        event, duration = pair.split ";dur="
        [event, duration.to_f]
      end
    end
  end
end
