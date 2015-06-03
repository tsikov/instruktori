set :output, "log/cron.log"

every :day do
  rake "update:results"
end

