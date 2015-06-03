set :output, "#{Whenever.path}/log/cron.log"

every :day do
  rake "update:results"
end

