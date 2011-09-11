# encoding: UTF-8
class HateDa::Bookmarks
  def initialize(username, total=nil)
    @username = username
    @total = total # total numbers of bookmarks
    @dataset = nil
  end

  def dataset
    urls = ( 0..total/PER_PAGE() ).map { |page| URL(page) }
    @dataset ||= get_dataset(urls)
  end

  def total(url=HOST(:diary))
    @total ||= get_total(url)
  end

  def clear
    @dataset, @total = nil, nil
  end

  def get_dataset(paths)
    htmls = Array(paths).thread_with { |path| open path }
    htmls.inject([]) { |mem, html| mem += parse(html) }
         .uniq.sort_by { |h| h[:time] }.reverse
  rescue OpenURI::HTTPError => e
    STDERR.puts "HTTP Access Error:#{e}"
  rescue Exception => e
    STDERR.puts e
  end

  private
  def get_total(url)
    client = XMLRPC::Client.new2( HOST(:xmlrpc) )
    client.call("bookmark.getTotalCount", url)
  rescue => e
    STDERR.puts "Fail to get Total number of Bookmarks: #{e}"
  end

  def HOST(target)
    { bmlist: "http://b.hatena.ne.jp/bookmarklist",
      diary:  "http://d.hatena.ne.jp/#{@username}",
      xmlrpc: "http://b.hatena.ne.jp/xmlrpc" }[target]
  end

  def URL(page=0)
    url = CGI.escape( HOST(:diary).encode "EUC-JP" )
    "%s?url=%s&of=%s" % [HOST(:bmlist), url, page*PER_PAGE()]
  end

  def PER_PAGE
    20
  end

  def parse(html)
    q = []
    entries = Nokogiri::HTML(html).search( CSS(:entry) )
    entries.each do |entry|
      link = entry.at( CSS(:site) ).attributes
      href, title = %w(href title).map { |e| link[e].value }
      comment = entry.at( CSS(:comment) )
      marker, tags, note, time =
          %w(username tags comment timestamp).map { |e| comment.at(".#{e}").content rescue '' }
      q << { url: href, title: title, marker: marker,
                 tags: tags.split(','), note: note, time: Time.parse(time) }
    end
    q
  end

  def CSS(at)
    { entry:   '.bookmarklist .entry-body',
      site:    'a.entry-link',
      comment: 'ul.comment>li' }[at]
  end
end

