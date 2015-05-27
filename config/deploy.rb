# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'instruktori'
set :repo_url, 'git@github.com:tsikov/instruktori.git'
set :scm, :git
set :format, :pretty
set :pty, true
set :linked_files,    %w(config/database.yml config/secrets.yml config/application.yml)
set :linked_dirs,     %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system)
set :keep_releases,   20
set :rails_env,       'production'
set :puma_init_active_record, true
set :nginx_server_name, 'instruktori.info *.instruktori.info'

set :server, ask('Enter the server:')

namespace :deploy do
  namespace :nginx do
    desc 'Generate an Nginx configuration file'
    task :config do
      on roles(:web) do |role|
        template_puma('nginx_conf', "#{shared_path}/#{fetch(:nginx_config_name)}_nginx.conf", role)
      end
    end
  end
end

after 'deploy:check', 'deploy:nginx:config'
after 'deploy:check', 'puma:config'
