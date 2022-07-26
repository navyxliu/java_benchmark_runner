#test
require_relative 'scores'
require 'enumerable/statistics'
require 'test/unit'

class MyTest < Test::Unit::TestCase
  def test_simple
    a = [1,2,3,4,5,6,7]
    assert_equal(mean(a), a.mean)
    assert_equal(stddev(a), a.stdev)
    assert_equal(median(a), a.median)
  end
end
