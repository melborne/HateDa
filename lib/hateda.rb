#!/usr/bin/env ruby
#-*-encoding: utf-8-*-

%w(open-uri nokogiri date).each { |lib| require lib }

module HateDa
  %w(entry_list extentions).each { |lib| require_relative "hateda/#{lib}" }
end

if __FILE__ == $0
  hd = HateDa::EntryList.new(:keyesberry)
  list = hd.get(1){ |url, title, date| date.between?("2010-12-1", "2011-1-25") }
  puts hd.print_list(list)
end

