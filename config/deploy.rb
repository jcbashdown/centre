require "bundler/capistrano" 

set :rvm_ruby_string, 'ruby-1.9.3-p286' 
# Or:
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
require "rvm/capistrano" # Load RVM's capistrano plugin.
set :rvm_type, :system  # Copy the exact line. I really mean :system here

default_run_options[:pty] = true
set :application, "wikistorm.org"
set :user, "jacob"
set :scm, :git
set :repository, "git@bitbucket.org:jcbashdown/centre.git"
set :deploy_to, "/www/wikistorm.org"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#server "your.server", :app, :web, :db, :primary => true
role :web, "wikistorm.org"                          # Your HTTP server, Apache/etc
role :app, "wikistorm.org"                          # This may be the same as your `Web` server
role :db,  "wikistorm.org", :primary => true # This is where Rails migrations will run
role :db,  "wikistorm.org"

# if you want to clean up old releases on each deploy uncomment this:
set :keep_releases, 5
after 'bundle:install', 'deploy:link_db'
after "deploy:restart", "deploy:cleanup" 
after 'deploy:link_db', 'deploy:migrate'
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :link_db do
     run <<-CMD
       cd #{release_path} &&
       #{try_sudo} ln -sf /www/centre/config/database.yml config/database.yml
     CMD
   end
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
