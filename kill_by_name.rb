#!/usr/bin/ruby

ARGV.each do |a|
  `pgrep -f #{a}`.split("\n").each do |pid|
    `echo 1 | sudo kill -9 #{pid}`
  end
end
