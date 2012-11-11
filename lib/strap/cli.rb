require 'thor'

module Strap

  class CLI < Thor
    
    desc "install", "Create '~/.strap' templates directory"
    def install
      if File.exists?(File.expand_path('~/.strap')) 
        say "'~/.strap' directory already exists\n", :red
      else
        Dir::mkdir(File.expand_path('~/.strap'))
        FileUtils.cp(CONFIG_TEMPLATE, File.expand_path('~/.strap/default'))
        say "'~/.strap' directory created. Add some template files.", :cyan
      end
    end
    
    desc "init PATH", "Initialize a new project directory at PATH and generate Strapfile"
    method_option :template, :aliases => "-t", :desc => "Specify a template Strapfile from '~/.strap'"
    def init(path)
      say ""
      if File.exists?(path)
        say "That directory already exists\n", :red
      else
        template = options[:template]
        core = Strap::Core.new(self)
        core.create_project_directory(path)
        core.create_config(path, template)
        core.update_database_name(path)
        say "\nStrap project created. Now edit the Strapfile and run 'strap go' from the project directory to bootstrap your project.\n\n"
      end
    end

    desc "go", "Bootstrap the project: clone bootstrap repo, create database, make first commit to project repo"
    def go(strapfile = "Strapfile")
      unless File.exists?(strapfile)
        say "\nNo Strapfile in current directory. Use the 'strap init PATH' command first to setup your project directory and to initialize a Strapfile.\n", :red
        return false
      end
      config = Strap::Config.new(strapfile)
      core = Strap::Core.new(self)
      core.clone_repo(config.source_repo)
      
      core.create_database(config.db_user, 
                           config.db_password, 
                           config.db_socket, 
                           config.db_name, 
                           config.db_port, 
                           config.db_host)
      
      core.import_to_database(config.sql, 
                              config.db_user, 
                              config.db_password, 
                              config.db_socket, 
                              config.db_name, 
                              config.db_port, 
                              config.db_host)
      
      core.commit_to_repo(config.destination_repo)
      
      config.run_after_bootstrap
    end  

  end
  
end