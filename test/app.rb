# frozen_string_literal: true

ENV["DATABASE_URL"] = "sqlite3::memory:"

class DialApp < Rails::Application
  config.eager_load = false
  config.logger = Logger.new nil
  config.active_support.deprecation = :silence

  def initialize!
    verbose = $VERBOSE
    $VERBOSE = nil
    super
  ensure
    $VERBOSE = verbose
  end
end

def app
  DialApp.new
end
