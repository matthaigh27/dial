# frozen_string_literal: true

require "vernier"

require_relative "ruby_stat"
require_relative "rails_stat"
require_relative "constants"
require_relative "panel"

module Dial
  class Middleware
    include RubyStat
    include RailsStat

    def initialize app
      @app = app
    end

    def call env
      start_time = ::Process.clock_gettime ::Process::CLOCK_MONOTONIC

      ruby_vm_stat_before = RubyVM.stat
      gc_stat_before = GC.stat
      gc_stat_heap_before = GC.stat_heap

      profile_out_dirname = String ::Rails.root.join PROFILE_OUT_RELATIVE_DIRNAME
      FileUtils.mkdir_p profile_out_dirname
      profile_out_filename = "#{SecureRandom.uuid}.json"
      profile_out_pathname = "#{profile_out_dirname}#{profile_out_filename}"

      status, headers, rack_body = nil
      ::Vernier.profile out: profile_out_pathname do
        status, headers, rack_body = @app.call env
      end

      unless headers[::Rack::CONTENT_TYPE]&.include? "text/html"
        File.delete profile_out_pathname if File.exist? profile_out_pathname
        return [status, headers, rack_body]
      end

      finish_time = ::Process.clock_gettime ::Process::CLOCK_MONOTONIC
      env[REQUEST_TIMING_HEADER] = ((finish_time - start_time) * 1_000).round 2

      ruby_vm_stat_diff = ruby_vm_stat_diff ruby_vm_stat_before, RubyVM.stat
      gc_stat_diff = gc_stat_diff gc_stat_before, GC.stat
      gc_stat_heap_diff = gc_stat_heap_diff gc_stat_heap_before, GC.stat_heap
      server_timing = server_timing headers

      body = String.new.tap do |str|
        rack_body.each { |chunk| str << chunk }
        rack_body.close if body.respond_to? :close
      end.sub "</body>", <<~HTML
          #{Panel.html env, profile_out_filename, ruby_vm_stat_diff, gc_stat_diff, gc_stat_heap_diff, server_timing}
        </body>
      HTML

      headers[::Rack::CONTENT_LENGTH] = body.bytesize.to_s

      [status, headers, [body]]
    end
  end
end
