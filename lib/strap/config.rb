module Strap
  
  class Config
    
    attr_accessor :db_name, :db_user, :db_password, :db_socket, :db_host, :db_port,
                  :sql, :source_repo, :destination_repo, :after
    
    def initialize(file)
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
      File.rename(old_name, new_name)
    end
    
    def change_permissions(permission, file)
      File.chmod permission, file
    end
        
  end
  
end