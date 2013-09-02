gem 'brightbox', '>=2.3.9'
require 'brightbox/recipes'
require 'brightbox/passenger'

set :application, "unicycle"
set :domain, "unicycle.woodpigeon.com"
server "woodpigeon-001.vm.brightbox.net", :app, :web, :db, :primary => true
set(:deploy_to) { File.join("", "home", user, application) }
set :repository, "."
set :scm, :none
set :deploy_via, :copy
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
