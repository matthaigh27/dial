# frozen_string_literal: true

require_relative "ruby_stat"
require_relative "rails_stat"
require_relative "constants"
require_relative "panel"

module Dial
  class Middleware
    include RubyStat
    include RailsStat
    include Constants

    def initialize app
      @app = app
    end

    def call env
      start_time = ::Process.clock_gettime ::Process::CLOCK_MONOTONIC

      ruby_vm_stat_before = RubyVM.stat
      gc_stat_before = GC.stat
      gc_stat_heap_before = GC.stat_heap

      status, headers, rack_body = @app.call env
      return [status, headers, rack_body] unless headers[::Rack::CONTENT_TYPE]&.include? "text/html"

      finish_time = ::Process.clock_gettime ::Process::CLOCK_MONOTONIC
      env[DIAL_REQUEST_TIMING] = ((finish_time - start_time) * 1_000).round 2

      ruby_vm_stat_diff = ruby_vm_stat_diff ruby_vm_stat_before, RubyVM.stat
      gc_stat_diff = gc_stat_diff gc_stat_before, GC.stat
      gc_stat_heap_diff = gc_stat_heap_diff gc_stat_heap_before, GC.stat_heap
      server_timing = server_timing headers

      body = String.new.tap do |str|
        rack_body.each { |chunk| str << chunk }
        rack_body.close if body.respond_to? :close
      end.sub "</body>", <<~HTML
          #{Panel.html env, ruby_vm_stat_diff, gc_stat_diff, gc_stat_heap_diff, server_timing}
        </body>
      HTML

      headers[::Rack::CONTENT_LENGTH] = body.bytesize.to_s

      [status, headers, [body]]
    end
  end
end
