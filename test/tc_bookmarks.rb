require "test/unit"

require_relative "../lib/hateda"
require "pp"

class TestBookmarks < Test::Unit::TestCase
  def setup
    @total = 1612
    @bm = HateDa::Bookmarks.new(:keyesberry)
  end

  def test_dataset_with_file
    path = Dir.pwd + '/test'
    ds = @bm.get_dataset([path+'/bm0.html', path+'/bm1.html'])
    p @bm.group_by_top(:marker, 10, ds)
  end

  def test_dataset
    # @bm.clear
    p @bm.dataset
  end

  def test_total
    url = "http://d.hatena.ne.jp/keyesberry"
    bms = @bm.total
    assert_equal(@total, bms)
  end
end
