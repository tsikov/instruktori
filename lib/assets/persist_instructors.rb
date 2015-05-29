require File.expand_path('../../../instruktori/config/environment',  __FILE__)
require 'csv'

source = ARGV[0]

CSV.foreach(source)

CSV.foreach(source).drop(1).each_with_index do |row, idx|
  ins = Instructor.create!({ name: row[1], city: row[2], address: row[3], phone: row[4], categories: row[5].split(", "), province: row[6], permit: row[0].to_i })
  puts "Instructor with id: #{ins.id} (#{ins.name}) was created."
end


