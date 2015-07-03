#!/usr/bin/env ruby

if ARGV.size != 1
  puts "usage: #{File.basename(__FILE__)} inputfile"
  exit
end


filename = ARGV[0]

# for "{{{" or "}}}"
flag=0

File.open(filename) do |f|
  f.each_line do |line|
    if line =~ /^##### /
      line.gsub!(/^##### /,"===== ")
      line.chomp!.concat(" =====\n")
    end
    if line =~ /^#### /
      line.gsub!(/^#### /,"==== ")
      line.chomp!.concat(" ====\n")
    end
    if line =~ /^### /
      line.gsub!(/^### /,"=== ")
      line.chomp!.concat(" ===\n")
    end
    if line =~ /^## /
      line.gsub!(/^## /,"== ")
      line.chomp!.concat(" ==\n")
    end
    if line =~ /^# /
      line.gsub!(/^# /,"= ")
      line.chomp!.concat(" ==\n")
    end
    if line =~ /^```/
      if flag == 0
        line.gsub!(/^```/,"{{{")
        flag = 1
      elsif flag == 1
        line.gsub!(/^```/,"}}}")
        flag = 0
      end
    end
    puts line
  end
end
