# frozen_string_literal: true

require_relative "constants"

module Dial
  class Panel
    class << self
      include Constants

      def html env, ruby_vm_stat, gc_stat, gc_stat_heap, server_timing
        <<~HTML
          <style>#{style}</style>

          <div id="dial">
            <div id="dial-preview">
              <span>#{formatted_rails_route_info(env)} | #{formatted_request_timing(env)}</span>
              <span>#{formatted_rails_version}</span>
              <span>#{formatted_rack_version}</span>
              <span>#{formatted_ruby_version}</span>
            </div>

            <div id="dial-details">
              <hr>

              <details>
                <summary>RubyVM stat</summary>
                <div class="section">
                  #{formatted_ruby_vm_stat(ruby_vm_stat)}
                </div>
              </details>

              <details>
                <summary>GC stat</summary>
                <div class="section">
                  #{formatted_gc_stat(gc_stat)}
                </div>
              </details>

              <details>
                <summary>GC stat heap</summary>
                <div class="section">
                  #{formatted_gc_stat_heap(gc_stat_heap)}
                </div>
              </details>

              <details>
                <summary>Server timing</summary>
                <div class="section">
                  #{formatted_server_timing(server_timing)}
                </div>
              </details>
            </div>
          </div>

          <script>#{script}</script>
        HTML
      end

      private

      def style
        <<~CSS
          #dial {
            z-index: 9999;
            position: fixed;
            bottom: 0;
            right: 0;
            background-color: white;
            border-top-left-radius: 1rem;
            box-shadow: -0.2rem -0.2rem 0.4rem rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
            padding: 0.5rem;
            font-size: 0.85rem;
            color: black;
            cursor: pointer;
          }

          #dial-preview {
            display: flex;
            flex-direction: column;
            cursor: pointer;
          }

          #dial-details {
            display: none;
          }

          .section {
            display: flex;
            flex-direction: column;
            margin-top: 0.5rem;
          }

          span {
            text-align: left;
          }

          hr {
            width: -moz-available;
            margin-top: 0.5rem;
          }

          details {
            margin-top: 0.5rem;
            text-align: left;
          }

          summary {
            margin-bottom: 0.25rem;
            cursor: pointer;
          }
        CSS
      end

      def script
        <<~JS
          const dialPreview = document.getElementById("dial-preview");
          const dialDetails = document.getElementById("dial-details");
          dialPreview.addEventListener("click", () => {
            const collapsed = ["", "none"].includes(dialDetails.style.display);
            dialDetails.style.display = collapsed ? "block" : "none";
          });
        JS
      end

      def formatted_rails_route_info env
        rails_route_info = begin
          ::Rails.application.routes.recognize_path env[::Rack::PATH_INFO], method: env[::Rack::REQUEST_METHOD]
        rescue ::ActionController::RoutingError
          {}
        end.then do |info|
          "<b>Controller:</b> #{info[:controller] || "NA"} | <b>Action:</b> #{info[:action] || "NA"}"
        end
      end

      def formatted_request_timing env
        "<b>Request timing:</b> #{env[DIAL_REQUEST_TIMING]}ms"
      end

      def formatted_rails_version
        "<b>Rails version:</b> #{::Rails::VERSION::STRING}"
      end

      def formatted_rack_version
        "<b>Rack version:</b> #{::Rack.release}"
      end

      def formatted_ruby_version
        "<b>Ruby version:</b> #{RUBY_DESCRIPTION}"
      end

      def formatted_ruby_vm_stat ruby_vm_stat
        ruby_vm_stat.map { |key, value| "<span><b>#{key}:</b> #{value}</span>" }.join
      end

      def formatted_gc_stat gc_stat
        gc_stat.map { |key, value| "<span><b>#{key}:</b> #{value}</span>" }.join
      end

      def formatted_gc_stat_heap gc_stat_heap
        gc_stat_heap.map do |slot, stats|
          <<~HTML
            <div class="section">
              <span><u>Heap slot #{slot}</u></span>
              <div class="section">
                #{gc_stat_heap[slot].map { |key, value| "<span><b>#{key}:</b> #{value}</span>" }.join}
              </div>
            </div>
          HTML
        end.join
      end

      def formatted_server_timing server_timing
        if server_timing.any?
          server_timing
            # TODO: Nested sorting
            .sort_by { |_, timing| -timing }
            .map { |event, timing| "<span><b>#{event}:</b> #{timing}</span>" }.join
        else
          "NA"
        end
      end
    end
  end
end
