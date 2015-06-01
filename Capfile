require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano/puma'
require 'capistrano/puma/jungle'
require 'capistrano/puma/nginx'
require 'capistrano/rbenv'
require "whenever/capistrano"

set :rbenv_ruby, '2.2.1'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
