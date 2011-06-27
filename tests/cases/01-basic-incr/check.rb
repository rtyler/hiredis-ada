#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

r = Redis.new
rc = r.get("simplekey")

if rc != '1' then
  puts "Redis returned \"#{rc}\" and I expected \"1\""
  exit 1
end

