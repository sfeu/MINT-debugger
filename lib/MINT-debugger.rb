 $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module MINTDebugger
  VERSION = '0.0.1'
end

require 'rubygems'
require "bundler/setup"
require 'dm-core'
require 'MINT-core'
require 'wx'
require 'time'

require "MINT-debugger/debugger2"
