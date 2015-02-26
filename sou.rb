#! /usr/bin/ruby

require "open-uri"
require "iconv"
require "nokogiri"
require "uri"

class SouPan
  attr_writer :keyword
  def initialize
    @keyword = ""
    @con = ""
    @conv = Iconv.new "utf-8", "gbk"  
  end
  def work
    self.getURL
  end
  def getURL
    ary = @keyword.split " "; @keyword = ary.join "%20" if @keyword.include? " "
    url = "http://209.85.228.22/custom?hl=zh-CN&sitesearch=pan.baidu.com&q=#{@keyword}"
    url = URI::escape url
    puts url
    self.request url
  end
  def request url
    system "clear"
    content = open(url).read
    @con = @conv.iconv content
    self.parse @con
  end
  def parse con
    page = Nokogiri::HTML con, nil, "utf-8"
    pgn = page.css("a")
    urlnext = pgn[pgn.length - 5]["href"]
    urlnext = "http://209.85.228.22#{urlnext}"    
    res = page.css("a.l")
    res.each do |link|
      puts link["href"]
      puts link.text.split("_")[0]
      puts ""
    end
    print "是否切换至下一页(y/n) "
    choice =$stdin.gets.chomp!
    begin
      request urlnext if choice == "y"
      exit
    rescue
    end   
  end
end


