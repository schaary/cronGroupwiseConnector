# encoding: utf-8

require "factory_girl"
require "minitest/autorun"
require "shoulda/context"
require "minitest/reporters"

reporter_options = { color: true  }
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(reporter_options)
