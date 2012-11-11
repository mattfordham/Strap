require_relative '../../test_helper'
require_relative '../../test_constants'
require "debugger"

describe Strap::CLI do
  
  before do
    @path = "test_project"
  end
  
  after do 
    FileUtils.remove_dir(@path) if File.directory?(@path)
  end
  
  it "should create a new project directory" do
    Strap::CLI.start ["init", @path]
    File.directory?(@path).must_equal true
  end
  
  it "should create a new Strapfile" do
    Strap::CLI.start ["init", @path]
    File.file?("#{@path}/#{Strap::CONFIG_FILENAME}").must_equal true
  end
  
  it "should update database name" do
    Strap::CLI.start ["init", @path]
    has_new_database_name = open("#{@path}/#{Strap::CONFIG_FILENAME}") { |f| f.grep(/set :db_name, "#{@path}"/) } 
    has_new_database_name.length.must_equal 1
  end
  
end