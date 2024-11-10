# frozen_string_literal: true

require "rails"

module Dial
  class Engine < ::Rails::Engine
    isolate_namespace Dial

    paths["config/routes.rb"] = ["lib/dial/engine/routes.rb"]
  end
end
