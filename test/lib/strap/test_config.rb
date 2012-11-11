require_relative '../../test_helper'
require_relative '../../test_constants'
require "debugger"

describe Strap::Config do
  
  before do
    @path = "test_path"
    File.new("old_name", "w")
    File.new("change_permissions", "w")
    @core = Strap::Core.new
    @core.create_project_directory(@path)
    @core.create_config(@path)
  end
  
  after do 
    FileUtils.remove_file("old_name") if File.file?("old_name")
    FileUtils.remove_file("new_name") if File.file?("new_name")
    FileUtils.remove_file("change_permissions") if File.file?("change_permissions")
    FileUtils.remove_dir(@path) if File.directory?(@path)
  end
  
  it "should set config variables" do
    @config = Strap::Config.new("test/lib/templates/#{Strap::CONFIG_FILENAME}")
    @config.db_name.must_equal "strap_tester"
    @config.db_user.must_equal Strap::Test::MYSQL_USER
    @config.db_password.must_equal Strap::Test::MYSQL_PASSWORD
    @config.db_socket.must_equal Strap::Test::MYSQL_SOCKET
    @config.db_host.must_equal Strap::Test::MYSQL_HOST
    @config.db_port.must_equal Strap::Test::MYSQL_PORT
    @config.source_repo.must_equal Strap::Test::SOURCE_REPO
    @config.destination_repo.must_equal Strap::Test::DESTINATION_REPO
  end
  
  it "should set 'after' block" do
    @config = Strap::Config.new("test/lib/templates/#{Strap::CONFIG_FILENAME}")
    @config.run_after_bootstrap
    @config.test.must_equal "it works!"
  end
  
  it "should rename a file" do
    File.file?("old_name").must_equal true
    @config = Strap::Config.new("test/lib/templates/#{Strap::CONFIG_FILENAME}")
    File.file?("new_name").must_equal true
  end
  
  it "should change file permissions" do
    @config = Strap::Config.new("test/lib/templates/#{Strap::CONFIG_FILENAME}")
    File.stat("change_permissions").mode.must_equal 33279
  end
  
end

module Strap
  class Config
    attr_accessor :test
    def test_method
      self.test = "it works!"
    end
  end
end