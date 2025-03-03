# frozen_string_literal: true

require "rails"

module Dial
  class Engine < ::Rails::Engine
    isolate_namespace Dial

    initializer "dial.assets" do |app|
      app.config.assets.paths << root.join("lib", "dial", "assets")
      app.config.assets.precompile += %w( dial.js dial.css )
    end

    paths["config/routes.rb"] = ["lib/dial/engine/routes.rb"]
  end
end
