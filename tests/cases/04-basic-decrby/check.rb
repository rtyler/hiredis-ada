#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

r = Redis.new
rc = r.get("simplekey")

if rc != '8' then
  puts "Redis returned \"#{rc}\" and I expected \"8\""
  exit 1
end

