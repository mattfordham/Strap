module Strap
  
  class Config
    
    attr_accessor :db_name, :db_user, :db_password, :db_socket, :db_host, :db_port,
                  :sql, :source_repo, :destination_repo, :after, :files_to_rename,
                  :files_to_change_permissions_on, :to_replace
    
    def initialize(file)
      self.files_to_rename = []
      self.files_to_change_permissions_on = []
      self.to_replace = []
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
    
    def replace_text(file, search, replace)
      self.to_replace << [file, search, replace]
    end
       
    def run_replace
      return false unless to_replace.length > 0
      to_replace.each do |search|
        file = search[0]
        text = File.read(file)
        updated_text = text.gsub(/#{search[1]}/, search[2])
        File.open(file, "w") do |file| 
          file.puts updated_text
        end
      end
    end
        
  end
  
end