#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

unless ARGV.count == 1
  exit 1
end

key = ARGV[0]

r = Redis.new
rc = r.get(ARGV[0])

if rc != '1' then
  puts "Redis returned \"#{rc}\" and I expected \"1\""
  exit 1
end

