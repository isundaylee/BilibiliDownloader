# encoding: utf-8

class PlaylistDownloader
  require_relative 'video_downloader'

  def self.inflate(string)
    begin
      Zlib::GzipReader.new(StringIO.new(string)).read
    rescue
      string
    end
  end

  def self.download_page(url, out_dir)
    require 'fileutils'
    require 'open-uri'
    require 'nokogiri'

    FileUtils.mkdir_p(out_dir)

    doc = Nokogiri::HTML(self.inflate(open(url).read))

    doc.css('.scontent iframe').each do |i|
      res = /cid=([0-9]*)/.match(i['src'])

      id = res[1]

      VideoDownloader.download(id, out_dir)

      break
    end
  end

  def self.download(id, out_dir, skip = 0)
    require 'fileutils'
    require 'open-uri'
    require 'nokogiri'

    FileUtils.mkdir_p(out_dir)

    url = "http://www.bilibili.tv/video/av#{id}/"

    doc = Nokogiri::HTML(self.inflate(open(url).read))

    count = 0
    all = doc.css('#dedepagestitles option').length

    doc.css('#dedepagetitles option').each do |v|
      title = v.content
      url = "http://www.bilibili.tv#{v['value']}"

      count += 1

      next if count <= skip

      puts "%03d / %03d 正在下载 %s" % [count, all, title]
      download_page(url, File.join(out_dir, title))
    end

  end

end

