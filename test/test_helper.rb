# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dial"
require "app"

require "minitest/autorun"

Minitest.after_run do
  FileUtils.rm_rf Rails.root.join "log"
  FileUtils.rm_rf Rails.root.join "tmp"
end
