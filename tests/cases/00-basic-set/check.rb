#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

r = Redis.new
rc = r.get("simplekey")

if rc != "simplevalue" then
  puts "Redis returned \"#{rc}\" and I expected \"#{value}\""
  exit 1
end

