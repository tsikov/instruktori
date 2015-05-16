source 'https://rubygems.org'

ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'

gem 'bootstrap-sass', '~> 3.3.4'

gem 'bower-rails'
gem 'angular-rails-templates'
gem 'angular-ui-bootstrap-rails'
gem 'will_paginate', '~> 3.0.6'

gem 'data_sync'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'responders', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'capistrano', '~> 3.3.0'

gem 'puma'

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'spring'
  gem "rspec-rails", "~> 2.0"
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
end

gem "foreman"
group :production, :staging do
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
end
