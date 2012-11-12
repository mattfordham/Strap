module Strap
  
  class Config
    
    attr_accessor :db_name, :db_user, :db_password, :db_socket, :db_host, :db_port,
                  :sql, :source_repo, :destination_repo, :after, :files_to_rename,
                  :files_to_change_permissions_on
    
    def initialize(file)
      self.files_to_rename = []
      self.files_to_change_permissions_on = []
      instance_eval File.read(file)
    end
    
    def set(key, value)
      instance_variable_set("@#{key}", value)
    end
    
    def after_bootstrap(&block)
      self.after = block
    end
    
    def run_after_bootstrap
      instance_eval &after if after
    end
    
    def rename_file(old_name, new_name)
      self.files_to_rename << [old_name, new_name]
    end
    
    def run_rename_files
      return false unless files_to_rename.length > 0
      files_to_rename.each do |file|
        File.rename(file[0], file[1]) 
      end
    end
    
    def change_permissions(permission, file)
      self.files_to_change_permissions_on << [permission, file]
    end
    
    def run_change_permissions
      return false unless files_to_change_permissions_on.length > 0
        files_to_change_permissions_on.each do |file|
        File.chmod file[0], file[1]
      end
    end
        
  end
  
end