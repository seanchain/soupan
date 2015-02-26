#! /usr/bin/ruby
#encoding: utf-8
require "open-uri"
require "iconv"
require "nokogiri"
require "uri"

class SouPan
  attr_reader :ary
  def initialize
    @con = ""
    @ary = Array.new
    @conv = Iconv.new "utf-8", "gbk"  
  end
  def work kwd
    @keyword = kwd
    self.getURL
  end
  def getURL
    ary = @keyword.split " "
    @keyword = ary.join "%20"
    url = "http://209.85.228.22/custom?hl=zh-CN&sitesearch=pan.baidu.com&q=#{@keyword}"
    url = URI::escape url
    self.request url
  end
  def request url
    #system "clear"
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
      @ary.push link["href"]
      @ary.push link.text.split("_")[0]
    end
    #print "是否切换至下一页(y/n) " 
  end
end

sp = SouPan.new

Shoes.app :width => 600, :height => 600 do
  background(white)
  @str = ""
  stack :width => 400, :margin => 20 do
    subtitle "百度网盘搜索"
    caption "输入搜索的关键词"
    @e = edit_line :width => 300
    button "提交" do
      sp.work @e.text
      sp.ary.each do |item|
        para "#{item}", "\n"
      end
    end
    para(link("Microsoft", :click => "http://www.baidu.com", :stroke => '#3085EB', :underline => false, :font => "Fira Sans"))
  end
  stack :width => 400, :margin => 20 do
    para "hello"
  end
end

