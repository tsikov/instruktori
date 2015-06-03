server "deployer@46.101.141.181", user: "deployer", roles: %w{web app db}, port: 11128

set :deploy_to,   -> { "/home/deployer/instruktori/" }
set :puma_threads,    [15, 15]
set :puma_workers,    4
