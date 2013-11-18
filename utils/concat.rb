#!/usr/bin/env ruby

require 'fileutils'

ffmpeg = "/Users/Sunday/Downloads/Safari\ Downloads/ffmpeg"

Dir['*'].each do |d|
  next if File.exists?("#{d}.flv")
  next unless File.directory?(d)

  FileUtils.mkdir_p('/tmp/cct'); 

  File.open(File.join('/tmp/cct', d), 'w') do |l|
    Dir["#{d}/*"].each do |f|
      l.puts("file '#{File.expand_path(f)}'")
    end
  end

  command = "\"#{ffmpeg}\" -f concat -i \"#{File.join('/tmp/cct', d)}\" -c copy \"#{d}.flv\""

  puts command
end