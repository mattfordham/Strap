lib_dir = File.expand_path("..", __FILE__)
$:.unshift( lib_dir ) unless $:.include?( lib_dir )

require "strap/version"
require "strap/core"
require "strap/config"
require "strap/cli"

module Strap
  
  CONFIG_FILENAME = "Strapfile"
  CONFIG_TEMPLATE = File.expand_path("../templates/#{CONFIG_FILENAME}", __FILE__)
    
end
