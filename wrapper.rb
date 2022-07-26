#!/usr/bin/env ruby 
require './scores'

RENAISSANCE="../renaissance-gpl-0.13.0.jar"
benchmarks = %x/java -jar #{RENAISSANCE} --raw-list/.split

puts "before"
#before
benchmarks.each do |b| 
  if File.exist? "#{b}_before.log"
    File.open("#{b}_before.log", 'r') do |f| 
      print "#{b}, "
      renassance_result f.readlines()
    end
  end
end

puts "after"
#after
benchmarks.each do |b| 
  if File.exist? "#{b}_after.log"
    File.open("#{b}_after.log", 'r') do |f| 
      print "#{b}, "
      renassance_result f.readlines()
    end
  end
end
