ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails/capybara"
require "mocha/mini_test"

class ActiveSupport::TestCase
  def assert_select_string(string, *selectors, &block)
    doc_root = HTML::Document.new(string).root
    assert_select(doc_root, *selectors, &block)
  end
end
