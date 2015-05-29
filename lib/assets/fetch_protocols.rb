require "mechanize"

date_regex = /\d{2}\.\d{2}\.\d{4}/
rails_root = ARGV[0]

agent = Mechanize.new
page = agent.get("file:///#{rails_root}/2015.html")
links = page.search("table div.hj_content td a")

destination_days =  Dir["public/system/html/*.html"].map { |f| f.match(date_regex)[0] }
source_days = links.map { |l| l["href"].match(date_regex)[0] }

protocols_to_fetch = source_days - destination_days

puts "Fetching #{protocols_to_fetch.length} new day(s)"

protocols_to_fetch.each do |day|
  `curl -L www.rta.government.bg/images/Image/izpiti_vodachi/#{day[6..-1]}/#{day}.html -o public/system/html/#{day}.html`
  sleep rand(2..5)
end

