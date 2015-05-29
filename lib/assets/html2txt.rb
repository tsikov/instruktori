require "mechanize"

html = File.open(ARGV[0]).read
# construct an "offline" page
page = Mechanize::Page.new(nil, { "content-type" => "text/html" }, html, nil, Mechanize.new)

# don"t print first tr - it contians all of them at once due to nested tables
page.search("tr")[1..-1].each do |n|
  puts n.text.gsub(/\r\n/, "").strip if n.text =~ /\S/
end

