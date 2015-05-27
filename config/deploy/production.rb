role :app, %w{deployer@46.101.141.181}
role :web, %w{deployer@46.101.141.181}
role :db,  %w{deployer@46.101.141.181}

server "deployer@46.101.141.181", user: "deployer", roles: %w{web app db}

set :deploy_to,   -> { "/home/deployer/instruktori/" }
set :puma_threads,    [15, 15]
set :puma_workers,    4
