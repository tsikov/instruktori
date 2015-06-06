set :output, "log/cron.log"
env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

every :day do
  rake "update:results"
end

