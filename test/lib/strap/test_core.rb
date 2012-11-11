require_relative '../../test_helper'
require_relative '../../test_constants'
require "debugger"

describe Strap::Core do
  
  before do
    @core = Strap::Core.new
    @path = "test_path"
  end
  
  after do 
    FileUtils.remove_dir(@path) if File.directory?(@path)
  end
  
  it "should create project directory" do
    @core.create_project_directory(@path)
    File.directory?(@path).must_equal true
  end
  
  it "should create config file in directory" do 
    @core.create_project_directory(@path)
    @core.create_config(@path)
    File.file?("#{@path}/#{Strap::CONFIG_FILENAME}").must_equal true
  end
  
  it "should extract project name from path" do
    path = "test/path/goes/here"    
    project_name = @core.extract_project_name_from_path(path)
    project_name.must_equal "here"
  end
  
  it "should update database name" do
    @core.create_project_directory(@path)
    @core.create_config(@path)
    @core.update_database_name(@path)
    has_new_database_name = open("#{@path}/#{Strap::CONFIG_FILENAME}") { |f| f.grep(/set :db_name, "#{@path}"/) } 
    has_new_database_name.length.must_equal 1
  end
  
  it "should clone a repo and cleanup after itself" do
    @core.create_project_directory(@path)
    @core.clone_repo(Strap::Test::SOURCE_REPO, @path)
    File.directory?("#{@path}/system").must_equal true
  end
  
  it "should initialize Git repo and push to new remote" do
    @core.create_project_directory(@path)
    @core.clone_repo(Strap::Test::SOURCE_REPO, @path)
    @core.commit_to_repo(Strap::Test::DESTINATION_REPO, @path, true)
    File.directory?("#{@path}/.git").must_equal true
  end
  
  it "should create a new database" do 
    mysql = Mysql::new(Strap::Test::MYSQL_HOST, Strap::Test::MYSQL_USER, Strap::Test::MYSQL_PASSWORD, nil, Strap::Test::MYSQL_PORT, Strap::Test::MYSQL_SOCKET)
    mysql.list_dbs.include?("strap_tester").must_equal false
    @core.create_database(Strap::Test::MYSQL_USER, Strap::Test::MYSQL_PASSWORD, Strap::Test::MYSQL_SOCKET, "strap_tester", Strap::Test::MYSQL_PORT, Strap::Test::MYSQL_HOST)
    mysql.list_dbs.include?("strap_tester").must_equal true
    mysql.query("DROP DATABASE strap_tester")
  end
  
  it "should import SQL to database" do
    @core.create_database(Strap::Test::MYSQL_USER, Strap::Test::MYSQL_PASSWORD, Strap::Test::MYSQL_SOCKET, "strap_tester", Strap::Test::MYSQL_PORT, Strap::Test::MYSQL_HOST)
    File.file?("test/sql/import_me.sql").must_equal true
    @core.import_to_database("test/sql/import_me.sql", Strap::Test::MYSQL_USER, Strap::Test::MYSQL_PASSWORD, Strap::Test::MYSQL_SOCKET, "strap_tester", Strap::Test::MYSQL_PORT, Strap::Test::MYSQL_HOST)
    mysql = Mysql::new(Strap::Test::MYSQL_HOST, Strap::Test::MYSQL_USER, Strap::Test::MYSQL_PASSWORD, "strap_tester", Strap::Test::MYSQL_PORT, Strap::Test::MYSQL_SOCKET)
    res = mysql.query("select * from test")
    res.num_rows.must_equal 3
    mysql.query("DROP DATABASE strap_tester")
  end
  
end