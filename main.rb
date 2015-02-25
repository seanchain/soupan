#! /usr/bin/ruby

require "./sou.rb"

keywd = ARGV.join " "

puts keywd

sp = SouPan.new
sp.keyword = keywd
sp.work
