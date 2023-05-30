# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

# replace obvious parts
server '192.168.0.100', port: 22, roles: [:web, :app, :db], primary: true
set :application, "hsdb"
set :repo_url, "https://github.com/puglet5/hsdb"
set :branch, "production"

set :user, 'hslab'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :rvm_ruby_version, '3.2.1'

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "public/uploads"
