#! /usr/bin/ruby

require "open-uri"
require "iconv"
require "nokogiri"

class SouPan
  attr_writer :keyword
  def initialize
    @keyword = ""
    @con = ""
  end
  def request
    conv = Iconv.new "utf8", "gbk"
    ary = @keyword.split " "
    @keyword = ary.join "%20"
    url = "http://209.85.228.22/custom?hl=zh-CN&sitesearch=pan.baidu.com&q=#{@keyword}"
    content = open(url).read
    @con = conv.iconv content
    self.parse @con
  end
  def parse con
    begin
      page = Nokogiri::HTML con, nil, "utf8"
      res = page.css("a.l")
      res.each do |link|
        puts link["href"].gsub(/wap/, "share")
        puts link.text
        puts ""
      end
    rescue
    end    
  end
end

sp = SouPan.new
sp.keyword = "Love Story m4a"
sp.request
