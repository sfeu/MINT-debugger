$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module MINTDebugger
  VERSION = '1.0.0'
end

require 'rubygems'
require "bundler/setup"
require 'dm-core'
require 'MINT-core'
require 'wx'
require 'time'

require "MINT-debugger/debugger2"

