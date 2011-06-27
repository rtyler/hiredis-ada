#!/usr/bin/env ruby

require 'rubygems'
require 'redis'

r = Redis.new
r.set("simplekey", 10)

