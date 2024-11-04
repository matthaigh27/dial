# frozen_string_literal: true

require "rails"

require_relative "middleware"

module Dial
  class Railtie < ::Rails::Railtie
    initializer "dial.use_middleware" do |app|
      app.middleware.insert_before 0, Middleware
    end
  end
end
