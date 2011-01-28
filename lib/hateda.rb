#!/usr/bin/env ruby
#-*-encoding: utf-8-*-

%w(open-uri nokogiri date cgi).each { |lib| require lib }

module HateDa
  %w(entry_list extentions).each { |lib| require_relative "hateda/#{lib}" }
end

if __FILE__ == $0
  hd = HateDa::EntryList.new('your account')
  list = hd.get(:pages => 1..-1, :word => '任天堂') do |url, title, date|
    date.between?("2007-1-1", "2009-1-1")
  end
  puts hd.print_list(list, :bookmark => false)
end

