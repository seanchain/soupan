#! /usr/bin/ruby

require "./sou.rb"

keywd = ARGV.join " "

sp = SouPan.new
sp.keyword = keywd
sp.work
