# encoding: utf-8

class VideoDownloader

  def self.download(id, out_dir, log_file = 'log')
    require 'fileutils'
    require 'open-uri'
    require 'xmlsimple'
    require 'logger'

    logger = Logger.new(log_file)

    downloaded_file = File.join(out_dir, 'downloaded')

    if File.exists?(downloaded_file)
      logger.info("已经完成 #{id}, 跳过")
      return 0
    end

    logger.info("开始下载 #{id}")

    FileUtils.rm_r(out_dir)
    FileUtils.mkdir_p(out_dir)

    url = "http://interface.bilibili.tv/v_cdn_play?cid=#{id}"
    xml = open(url).read
    str = XmlSimple.xml_in(xml)

    ap = str['durl'].length

    aria_file = File.join(out_dir, "urls")

    File.open(aria_file, 'w') do |lf|
      str['durl'].each do |e|
        order = e['order'][0]
        url = e['url'][0]
        path = File.join(out_dir, "#{order}#{File.extname(URI.parse(url).path)}")
        lf.puts url
        lf.puts "  out=#{path}"
      end
    end

    command = "aria2c -i \"#{aria_file}\"  --summary-interval=1 --show-console-readout=false"
    system(command)

    if $? == 0
      logger.info("成功下载 #{id}")
      FileUtils.touch(downloaded_file)
    else
      logger.info("未成功下载 #{id}")
    end

    $?
  end

end
