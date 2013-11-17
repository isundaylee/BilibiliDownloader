# encoding: utf-8

class VideoDownloader

  def self.download(id, out_dir)
    require 'fileutils'
    require 'open-uri'
    require 'xmlsimple'

    FileUtils.mkdir_p(out_dir)

    url = "http://interface.bilibili.tv/v_cdn_play?cid=#{id}"
    xml = open(url).read
    str = XmlSimple.xml_in(xml)

    ap = str['durl'].length

    str['durl'].each do |e|
      order = e['order'][0]
      url = e['url'][0]
      path = File.join(out_dir, "#{order}#{File.extname(URI.parse(url).path)}")

      command = "curl --retry 999 --retry-max-time 0 -C - -# \"#{url}\" -o \"#{path}\""


      puts "正在下载 #{id} 第 #{order} / #{ap} 部分"
      system(command)
    end

  end

end
