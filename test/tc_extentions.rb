require "test/unit"

require "date"
require_relative "../lib/hateda/extentions"

class TestLibExtentions < Test::Unit::TestCase
  def setup
    @date = Date.parse("2010/1/1")
  end

  def test_before?
    assert(@date.before?("2010/12/31"), "Failure message.")
  end

  def test_after?
    assert(@date.after?("2009-12-3"), "Failure message.")
  end
  
  def test_sameday?
    assert(@date.sameday?("2010-1-1"), "Failure message.")
  end

  def test_between?
    assert(@date.between?("2009-12-31", "2010-2-1"), "Failure message.")
  end
end
