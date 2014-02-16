$:.unshift(File.join(File.dirname(__FILE__), '..', 'libraries')) # rubocop: disable SpecialGlobalVars
require 'helpers'
require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }
