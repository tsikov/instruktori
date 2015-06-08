def rename_instructor(old_name, new_name)
  ins = Instructor.find_by(name: old_name)
  unless ins.nil?
    ins.name = new_name
    ins.save!
    puts "Instructor #{old_name} renamed -> #{new_name}"
  else
    puts "Already renamed #{old_name} -> #{new_name}"
  end
end

def create_instructor(name)
  ins = Instructor.find_by(name: name)

  if ins.nil?
    ins = Instructor.create!({ name: name })
    puts "Instructor #{name} created"
  else
    puts "Already created #{name}"
  end
end

namespace :instructors do

  file "instructors-#{Time.now.to_s[0..9]}.html" do |t|
    sh "curl -o instructors-#{Time.now.to_s[0..9]}.html http://www.rta.government.bg/index.php?page=scategories&scategory=teoria#top"
  end

  task :update => ["instructors-#{Time.now.to_s[0..9]}.html"] do |t|
    require "mechanize"

    agent = Mechanize.new
    p t.source
    page = agent.get("file:///#{Rails.root}/#{t.source}")
    links = page.at("table div.hj_content").search("hr")
    p links

  end

  task :persist => :environment do |t|
    require 'csv'

    CSV.foreach("public/system/instructors.csv").drop(1).each_with_index do |row, idx|
      ins = Instructor.create!({ name: row[1], city: row[2], address: row[3], phone: row[4], categories: row[5].split(", "), province: row[6], permit: row[0].to_i })
      puts "Instructor with id: #{ins.id} (#{ins.name}) was created."
    end
  end

  task :patch => :environment do |t|
    rename_instructor "'ВАЛЕНТИ АУТО'' ЕООД", "\"ВАЛЕНТИ АУТО\" ЕООД"
    rename_instructor "ПРОФЕСИОНАЛНА  АГРОТЕХНИЧЕСКА ГИМНАЗИЯ\"Н. Й. ВАПЦАРОВ\"", "ПРОФЕСИОНАЛНА АГРОТЕХНИЧЕСКА ГИМНАЗИЯ \"Н. Й. ВАПЦАРОВ\""

    # Not found in list -> ask the institutions about these
    create_instructor "\"МЕРИДИАН 888\" ЕООД"
    create_instructor "ЕТ \"АПИС - МАРИЯ СТОЯНОВА\""
    create_instructor "\"ВИТА - 6\" АД"
    create_instructor "ИЗПЪЛНИТЕЛНА АГЕНЦИЯ АВТОМОБИЛНА АДМИНИСТРАЦИЯ"
    create_instructor "ПРОФЕСИОНАЛНА ГИМНАЗИЯ"     # perhaps known - should ask the gov.
    create_instructor "\"СТРЕЛЕЦ - 09\" ЕООД"
    create_instructor "ЕТ \"ПАЛАС - КИРЧО СИМИТЧИЕВ\""
    create_instructor "ЕТ \"КИРИЛ БЪЧВАРОВ\""
    create_instructor "ЕТ \"ОЛИМП - 99 - ДИМЧО ИЛИЕВ\""
    create_instructor "\"ЗЕНИТ - МВ\" ООД"
    create_instructor "\"ТОМОВ БИЗНЕС ГРУП\" ЕООД"
    create_instructor "БОРИ ДД"    # perhaps should rename to БОРИ 11???
  end

  task :update_score => :environment do |t|

    Instructor.all.each do |i|
      results = i.results.map(&:result).keep_if { |r| r.in? [0, 1] }

      if results.empty?
        i.score = 0
      else
        # 1 -, because 1 means "failure"
        score = 1 - results.sum.to_f/results.count
        i.score = score
      end

      i.save
      puts "Score #{i.score} for instructor with id #{i.id} saved."
    end

  end

end
