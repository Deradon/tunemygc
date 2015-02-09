# encoding: utf-8

ENV['RUBY_GC_TOKEN'] = 'testapp'

require 'rails'
require 'tunemygc'
require "tunemygc/syncer"
require 'minitest/autorun'
require 'webmock/minitest'

WebMock.disable_net_connect!

require File.join(File.dirname(__FILE__), 'fixtures')

class TuneMyGcTestCase < Minitest::Test
  if ENV['STRESS_GC'] == '1'
    def setup
      GC.stress = true
    end

    def teardown
      GC.stress = false
    end
  end

  def process_tunemygc_request(path = '/test')
    ActiveSupport::Notifications.instrument('start_processing.action_controller', path: path) {}
    ActiveSupport::Notifications.instrument('process_action.action_controller', path: path) {}
  end

  def run_tunemygc_test
    suite = MinitestSandboxTest.new("test_minitest_spy")
    suite.run
  end
end

# for Minitest spy
class MinitestSandboxTest < MiniTest::Unit::TestCase
  def setup
    @value = 123
  end

  def test_minitest_spy
    assert_equal 123, @value
  end
end