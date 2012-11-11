require 'mysql'

module Strap
  
  class Core
    
    attr_accessor :cli
    
    def initialize(cli = nil)
      self.cli = cli
    end
    
    def create_project_directory(path)
      output "- Creating project directory: #{path}"
      Dir::mkdir(path)
    end
    
    def create_config(path, template = nil)
      strapfile = "#{path}/#{CONFIG_FILENAME}"
      output "- Writing new config to #{strapfile}"
      if template
        config = File.expand_path(File.expand_path("~/.strap/#{template}"))
      elsif File.exists?(File.expand_path('~/.strap/default'))
        config = File.expand_path(File.expand_path('~/.strap/default'))
      else
        config = CONFIG_TEMPLATE
      end
      FileUtils.cp(config, strapfile)
    end
    
    def extract_project_name_from_path(path)
      path.match(/\w*$/).to_s
    end
    
    def update_database_name(path)
      project_name = extract_project_name_from_path(path) 
      bootfile = "#{path}/#{CONFIG_FILENAME}"
      bootfile_text = File.read(bootfile)
      temporary_database_name = /set :db_name,\s*("\w*")/.match(bootfile_text)[0]
      updated_boofile_text = bootfile_text.gsub(/#{temporary_database_name}/, "set :db_name, \"#{project_name}\"")
      File.open(bootfile, "w") do |file| 
        file.puts updated_boofile_text
      end
    end
    
    def clone_repo(repo, directory=".")
      if !repo.empty? && !File.exists?("#{directory}/.git")
        output "- Cloning source repo"
        clone = system("cd #{directory} && git clone #{repo} strap_temp")
        unless clone
          output "- Source repo clone failed", :error
          exit
        end
        remove_tmp = system("cd #{directory} && shopt -s dotglob && mv strap_temp/* . && rm -rf strap_temp/* && rm -rf .git")
        unless remove_tmp
          output "- Removal of temporary clone failed", :error
          exit
        end
      else
        output "- No source repo provided", :error
        exit
      end
    end
    
    def commit_to_repo(repo, directory=".", force=false)
      if !repo.empty?
        commit = system("cd #{directory} && git init . && git add -A && git commit -m 'Initial commit from Strap'")
        if commit
          output "- Git repo initialized"
          push = system("cd #{directory} && git remote add origin #{repo} && git push #{"-f" if force} origin master")
          if push 
            output "- Project pushed to destination repo"
          else
            output "- Git push to destination repo failed", :error
            exit
          end
        else
          output "- Git init failed", :error
          exit
        end
      end
    end
    
    def create_database(db_user, db_password, db_socket=nil, db_name=nil, db_port=nil, db_host=nil)
      if db_user.empty? and db_password.empty? and db_name.empty?
        return false
      end
      mysql = Mysql::new(db_host, db_user, db_password, nil, db_port, db_socket)
      output("- Error connecting to MySQL", :error) unless mysql
      db_exists = mysql.list_dbs.include?(db_name)
      if db_exists
        output "- Database already exists", :error
      else
        mysql.query("CREATE DATABASE #{db_name}")
        mysql.list_dbs.include?(db_name) ? output("Database created") : output("Error creating database", :error)
      end
    end
    
    def import_to_database(sql, db_user, db_password, db_socket=nil, db_name=nil, db_port=nil, db_host=nil)
      if db_user.empty? and db_password.empty? and db_name.empty? and sql.empty?
        return false
      end
      import = system("mysql -u#{db_user} -p#{db_password} -S#{db_socket} #{db_name} < #{sql}")
      if import
        output "- Database dump imported"
      else
        output "- Database import failed", :error
        exit
      end
    end
    
    private
    
    def output(message, message_type = :notice)
      if @cli
        if message_type == :error
          @cli.say message, :red
        elsif message_type == :notice
          @cli.say message, :cyan
        end
      else
        puts message
      end  
    end
    
  end
    
end