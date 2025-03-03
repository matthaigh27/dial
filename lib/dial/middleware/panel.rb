# frozen_string_literal: true

require "uri"

module Dial
  class Panel
    class << self
      def html(env, profile_out_filename, query_logs, ruby_vm_stat, gc_stat, gc_stat_heap, server_timing)
        panel_data = {
          rails: {
            controller: extract_controller(env),
            action: extract_action(env),
            version: ::Rails::VERSION::STRING
          },
          request: {
            timing: env[REQUEST_TIMING]
          },
          profile: {
            uuid: profile_out_filename&.delete_suffix(".json.gz"),
            host: env[::Rack::HTTP_HOST]
          },
          rack: {
            version: ::Rack.release
          },
          ruby: {
            version: ::RUBY_DESCRIPTION
          },
          queryLogs: query_logs,
          serverTiming: server_timing,
          rubyVmStat: ruby_vm_stat,
          gcStat: gc_stat,
          gcStatHeap: gc_stat_heap
        }

        "<dial-panel data-dial=\"#{h(panel_data.to_json)}\"></dial-panel>"
      end

      private

      def extract_controller(env)
        route_info = recognize_path(env)
        route_info[:controller]
      end

      def extract_action(env)
        route_info = recognize_path(env)
        route_info[:action]
      end

      def recognize_path(env)
        @recognize_path ||= begin
          ::Rails.application.routes.recognize_path env[::Rack::PATH_INFO], method: env[::Rack::REQUEST_METHOD]
        rescue ::ActionController::RoutingError
          {}
        end
      end
    end
  end
end
