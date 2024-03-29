# create folders if needed
%w(html txt txt_patched json).each do |folder|
  FileUtils.mkdir_p "public/system/#{folder}"
end

# all dependancies are constructed from the html files
html_files = Rake::FileList.new("public/system/html/**")
txt_files = html_files.pathmap("%{html,txt}X.txt")
patched_txt_files = txt_files.pathmap("%{txt,txt_patched}d/%n_patched.txt")
json_files = patched_txt_files.pathmap("%{txt_patched,json}d/%{_patched,}n.json")

namespace :results do
  task :update => [:clean, :fetch_protocols, :to_json]

  desc "Convert the html to txt files"
  task :to_txt => txt_files
  rule ".txt" => ->(f) { f.pathmap("%{txt,html}X.html") } do |t|
    sh "ruby lib/assets/html2txt.rb #{t.source} > #{t.name}"
  end

  desc "Patches the txt files"
  task :patch_txt => patched_txt_files
  rule(/_patched\.txt/ => ->(f) { f.pathmap("%{txt_patched,txt}d/%{_patched,}n.txt") } ) do |t|
    sh "ruby lib/assets/patch_txt.rb #{t.source} > #{t.name}"
  end

  desc "Converts the patched txt files to json files"
  task :to_json => json_files
  rule ".json" => ->(f) { f.pathmap("%{json,txt_patched}d/%n_patched.txt") } do |t|
    sh "ruby lib/assets/txt2json.rb #{t.source} > #{t.name}"
  end

  task :persist => :environment do |t|
    all_dates_db = Exam.select("DISTINCT date").map(&:date).map { |d| d.strftime ("%d.%m.%Y") }
    all_dates_files = html_files.pathmap("%n")
    days_to_persist = all_dates_files - all_dates_db
    puts "New days to persist: #{days_to_persist}"
    days_to_persist.each do |day|

      ob = JSON.parse(File.open("public/system/json/#{day}.json").read)
      raise "Date not found" if ob["date"].blank?
      date = ob["date"].to_date

      ob["by_municipality"].each do |municipality, data|

        data.each do |ex|

          raise "Unknown exam kind: #{ex["kind"]}" if ex["kind"].in? ["ПРАКТИЧЕСКИ", "ТЕОРЕТИЧЕН"]
          raise "Examiner is missing for #{ex}" if ex['examiner_name'].blank?
          raise "Protocol # is missing for #{ex}" if ex["protocol_number"].blank?

          new_exam = {
            protocol: ex["protocol_number"],
            date: date,
            examiner: ex["examiner_name"],
            kind: ex["kind"] == "ПРАКТИЧЕСКИ" ? 1 : 0
          }
          exam_inst = Exam.create!(new_exam)

          all_results = []

          # persist the results
          ex["results"].each do |r|

            instructor_name = r["instructor"].strip
            instructor = Instructor.find_by(name: instructor_name)

            #raise "Instructor not found by name: #{r}" if instructor.nil?
            if instructor.nil?

              puts "Couldn't find instructor: #{instructor_name}. Created and added to the list."
              instructor = Instructor.create!({ name: instructor_name })
              File.open('unknown_or_renamed_instructors.txt', 'a') { |f| f.puts instructor_name }

            end

            raise "Student not found for: #{r}" if r["student_name"].blank?

            res = case r["exam_result"]
                  when "Издържал"   then 0
                  when "Неиздържал" then 1
                  when "Неявил се"  then 2
                  when nil          then 3
                  else              raise "Exam result not found for: #{r}"
                  end

            all_results << {
              instructor: instructor,
              exam: exam_inst,
              # TODO: Titlelize names
              student_name: r["student_name"].strip,
              result: res,
              notes: r["notes"]
            }
          end

          Result.transaction do
            Result.create!(all_results)
          end

        end

      end

    end
  end

  task :fetch_protocols => ["2015.html"] do
    sh "ruby lib/assets/fetch_protocols.rb #{Rails.root.to_s}"
  end

end

task :clean do
  rm_rf "2015.html"
end

task :populate_db => [:persist_instructors, :patch_instructors, :persist_all_results]

file "2015.html" do |t|
  sh "curl -L http://www.rta.government.bg/index.php?page=rezultati_izpit_vodachi -o 2015.html"
end

# ====== Analisist =======


