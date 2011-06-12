#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

unless ARGV.count == 2
  exit 1
end

key = ARGV[0]
value = ARGV[1]

r = Redis.new
rc = r.get(ARGV[0])

if rc != value then
  puts "Redis returned \"#{rc}\" and I expected \"#{value}\""
  exit 1
end

