# encoding: UTF-8
require "xmlrpc/client"

class Date
  def before?(date)
    comp(date) == -1
  end

  def after?(date)
    comp(date) == 1
  end

  def sameday?(date)
    comp(date) == 0
  end
  
  alias _between? between?
  def between?(min, max)
    min, max = [min, max].map { |d| Date.parse d }
    _between?(min, max)
  end
  private
  def comp(date)
    self <=> Date.parse(date)
  end
end

module XMLRPC::ParseContentType
  def parse_content_type(str)
    a, *b = str.split(";")
    a = "text/xml" if a == "application/xml"
    return a.strip.downcase, *b
  end
end

module Enumerable
  def thread_with(order=false)
    mem = []
    map.with_index do |*item, i|
      Thread.new(*item) do |*_item|
        mem << [i, yield(*_item)]
      end
    end.each(&:join)
    (order ? mem.sort : mem).map(&:last)
  end
end

module Kernel
  def requires(*features)
    features.each { |f| require f.to_s }
  end
end

class Fixnum
  def day
    self*60*60*24
  end
  alias days day
end

