# Strap

Strap is a simple tool for bootstrapping new projects based on a template Git repo. With a couple commands, it will check out the
specified repo into a new project directory, do some stuff*, initialize a new Git repo and push to the project's remote repo. 

\* Before committing to the new repo, strap can create a database, import SQL, rename files and change file permissions.

## Installation

Add this line to your application's Gemfile:

    gem 'strap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strap

## Usage

### Bootstrapping a new project

To bootstrap a new project, execute:

    $ strap init path/to/project
    
In the above example, the project directory will be named "project". This command will simply create the project directory and
drop a "Strapfile" in it for you to configure. 

Once the Strapfile has been configured to your specific needs (more on that below), execute:

    $ strap go
    
This command will check out the template repo specified in the Strapfile, run some some optional tasks and push the new project
to a remote repo, if one was specified. 

### The Strapfile

After running `strap init PATH`, you'll need to edit the project's Strapfile before running `strap go`. The Strapfile is where 
you tell Strap what to do. All the options available to you are described in the default Strapfile:

    ## REPO SETTINGS
    ## ---------------------------
    ## Source repo is required. Repo will be cloned into new project.

    set :source_repo, ""

    ## If 'destination_repo' is set, Strap will initialize a new Git repo
    ## and push to specified remote destination.
    # set :destination_repo, ""


    ## DATABASE SETTINGS
    ## ---------------------------
    ## If you set at least 'db_name', 'db_user', and 'db_password', Strap
    ## will attempt to create a database for you.

    # set :db_name, ""
    # set :db_user, ""
    # set :db_password, ""
    # set :db_socket, ""
    # set :db_host, ""
    # set :db_port, ""

    ## If you specify an SQL file below, it'll be imported into your new DB.
    # set :sql, ""


    ## FILE UTILITIES
    ## ---------------------------

    ## Use this to rename a file before it gets committed to new repo
    # rename_file "path/to/old_name", "path/to/new_name"

    ## Use this to change permissions of a file before it gets committed
    # change_permissions 0777, "change_permissions"


    ## CUSTOM COMMANDS
    ## ---------------------------
    ## Use after_bootstrap to execute any custom Ruby code after the
    ## bootstrap process

    after_bootstrap do
      # Do something using Ruby
    end

At the very least, you'll need to set a source repo (otherwise there really isn't any point to using the tool). 

### Strapfile Templates

You may find that you'd like to customize the template Strapfile, or use multiple. To do this, first run the 
following command:

    $ strap install

This will create a ".strap" directory in your user home directory. Inside, you'll find a "default" Strapfile. 
Edit this to change the default. Additionally, you can create other templates. For example if you put a 
file named "wordpress" in the ".strap" directory containing settings for your default Wordpress install, you 
could use "-t" flag to specify this custom template:

    $ strap init path/to/project -t wordpress

The contents of the new project's Strapfile will match that of the "wordpress" template. 

## Inspiration

This project was inspired by Carl Crawley's EECI 2012 talk on bootstrapping ExpressionEngine. In particular, the bash script 
he shared got me thinking. Thanks Carl! https://bitbucket.org/cwcrawley/eeci-talk-files/

## To-do

* Add some more tests for CLI commands
* Figure out a way to mock file system actions in tests, the files don't actually have to be created
* Test in environments other than Mac OSX.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
