$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module MINT_DEBUGGER
  VERSION = '1.0.0'
end

require "MINT-debugger/debugger2"