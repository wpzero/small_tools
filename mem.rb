#!/usr/bin/ruby

require 'open3'

a = ARGV.first

command = <<-EOF
             watch 'ps x -o pid,rss,vsz,command | grep "#{a}" | grep -vv "grep"'
             EOF

puts command

system(command, out: $stdout, err: :out)
