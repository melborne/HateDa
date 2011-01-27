#-*-encoding: utf-8-*-
class HateDa::EntryList
  def initialize(username)
    @user = username
    @pages = {}
  end

  def get(pages=1..-1, word='', &blk)
    htmls = parse_pages build_page_range(pages), word
    extract_entries(htmls, &blk)
  end

  def print_list(list, bookmark=true, day=true, lineno=true)
    raise "you get no entries or need to call get first." if list.empty? 
    list.map do |url, (title, date)|
      form = ->d{ "[#{url}:title=#{title}#{d}]" }
      out = day ? form["(#{date})"] : form[nil]
      bookmark ? out += "[#{url}:bookmark]" : out
      lineno ? "+" + out : out
    end
  end

  private
  def extract_entries(htmls, &blk)
    q = {}
    htmls.each do |html|
      html.search('.archive-date').each do |elm|
        date = Date.parse(elm.child.text)
        elm.css('li').each do |entry|
          url = entry.child.attributes['href'].value
          title = entry.child.child.content
          q[url] = [title, date]
        end
      end
    end
    blk ? filter(q, &blk) : q
  end

  def filter(q, &blk)
    q.select { |url, (title, date)| yield(url, title, date) }
  end

  DEFAULT_MAX = 10
  def build_page_range(pages)
    case pages
    when Integer
      pages..pages
    when Range
      pages.begin <= pages.end ?  pages : pages.begin..DEFAULT_MAX
    else
      raise 'wrong pages set.'
    end
  end

  def URL(username, page=0, word='')
    word = CGI.escape(word.encode "EUC-JP") if word
    "http://d.hatena.ne.jp/#{username}/archive?word=#{word}&of=#{(page-1)*50}"
  end

  def parse_pages(pages, word)
    q = {}
    @pages.clear unless word.nil?
    # TODO: be thread
    pages.each do |page|
      q[page] = @pages[page] ||= Nokogiri::HTML(open URL(@user, page, word))
      break if last_page?(q[page])
    end
    q.sort_by(&:first).map(&:last)
  rescue OpenURI::HTTPError => e
    STDERR.puts "maybe Account name is wrong.:#{e}"
    exit
  end

  def last_page?(html)
    html.search('a.prev').empty?
  end
end
