require 'json'

source = ARGV[0]

ob = JSON.parse(File.open(source).read)
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

