#-*-encoding: utf-8-*-
require "test/unit"

require_relative "../lib/hateda"

class TestHateDaEntryList < Test::Unit::TestCase
  def setup
    @hd = HateDa::EntryList.new(:keyesberry)
  end
  
  def test_entry_with_page_range
    assert_equal(260+86, @hd.get.size)
    assert_equal(60, @hd.get(:pages => 2).size)
    assert_equal(180, @hd.get(:pages => 1..3).size)
  end

  def test_entry_with_word
    assert_equal(4, @hd.get(:word => "tiger").size)
    assert_equal(11, @hd.get(:word => "株価").size)
  end

  def test_entry_with_filter
    list1 = @hd.get(:pages => 1) { |url, title, date| title =~ /ruby/i }
    list2 = @hd.get(:pages => 3..20) { |url, title, date| date.before?('2007-1-1') }
    list1.each { |k,(t,d)| assert_match(/ruby/i, t) }
    list2.each { |k,(t,d)| assert(d.before?('2007-1-1'), "Failure message.") }
  end
  
  def test_print_list
    list = @hd.get(:pages => 2) { |url, title, date| title =~ /ruby/i }
    @hd.print_list(list).each { |ent| assert_match(/ruby/i, ent) }
  end
  
  def test_print_list_option
    list = @hd.get(:pages => 1)
    w_bm_day  = @hd.print_list(list)
    wo_bm_day = @hd.print_list(list, :bookmark => false, :day => false)
    wo_bm     = @hd.print_list(list, :bookmark => false)
    assert_match(/:bookmark/, w_bm_day[1])
    assert_match(/\d{4}-\d{2}-\d{2}/, w_bm_day[1])
    assert_no_match(/\d{4}-\d{2}-\d{2}/, wo_bm_day[1])
    assert_no_match(/:bookmark/, wo_bm_day[1])
    assert_no_match(/:bookmark/, wo_bm[1])
  end
end
