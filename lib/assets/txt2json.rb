# This code is responsible for getting the raw txt file and transforming it into a
# structured JSON with proper names.

require 'json'

def fix_spaces str
  str
  .strip                                    # remove all surrounding whitespace
  .gsub(/[[:space:]]+/, " ")                # remove double/triple/etc... spaces between names
end

def split_by_municipalities(text, date)
  municipalities = ["Благоевград", "Бургас", "Варна", "Велико Търново",
   "Видин", "Враца", "Габрово", "Добрич", "Кърджали", "Кюстендил",
   "Ловеч", "Монтана", "Пазарджик", "Перник", "Плевен", "Пловдив",
   "Разград", "Русе", "Силистра", "Сливен", "Смолян", "София",
   "Стара Загора", "Търговище", "Хасково", "Шумен", "Ямбол"]

  ob = {
    date: date,
    by_municipality: {}
  }

  municipalities[0...-1].each_with_index do |m, idx|

    result = text.match(/#{m}.*(?=#{municipalities[idx+1]})/m)

    raise "#{m} or #{municipalities[idx+1]} not found in #{date}" if result.nil?

    ob[:by_municipality][m] = split_by_protocols(result[0], m)
  end

  ob.to_json
end

def split_by_protocols(text, municipality)
  protocols_regex = /ПРОТОКОЛ\s№\s\d+\s\/\s+.*?(?=ПРОТОКОЛ\s№\s|\Z)/m
  instructors_regex = /^(\d+)\.\s+(\S.*)$/
  exam_results_check_regex = /^(\d+)\s/
  exam_results_regex = /
    ^                                                                                            # beginning of line
    (\d+)                                                                                        # get number
    \s+                                                                                          # arbitrary space
    (.*)?                                                                                        # get the name of the student
    \s+                                                                                          # space
    (A|A1|A2|AM|B|B1|B\+E|B\s\(78\)|C|C1|C\+E|D|D1|D1\+E|D\s\(103\)|P\s\(171\)|Ткт|Ттб|Ттм)      # get category of vehicle
    \s+                                                                                          # space
    (Издържал|Неиздържал|Неявил\sсе)?                                                            # get result of exam
    \s+                                                                                          # space
    (\d+)                                                                                        # get instructor number
    (.*)                                                                                         # get notes (if any)
    $                                                                                            # end of line
    /x

  all_results = text.scan(exam_results_check_regex)
  fetched_results = text.scan(exam_results_regex)

  # check if all exam results passed through the thourough scan
  if all_results.length != fetched_results.length

    #puts fetched_results
    puts municipality

    puts "=== fr: #{fetched_results.length} ar: #{all_results.length} ==="
    puts "fr: " + fetched_results.map { |fr| fr[0] }.join(", ")
    puts "ar: " + all_results.map { |ar| ar[0] }.join(", ")

    raise "STOP"
  end

  text.scan(protocols_regex).map do |result|

    instructors = result.scan(instructors_regex).to_h
    exam_results = result.scan(exam_results_regex)
    results = []

    exam_results.each do |er|

      raise "Couldn't find instructor #{er[4]} in instructors: #{instructors} | Result: #{er}" if instructors[er[4]].nil?

      # instructor name
      instructor_name = fix_spaces instructors[er[4]]

      results << {
        number: er[0],
        student_name: er[1].gsub(/\s+/, " "),
        exam_result: er[3],
        instructor: instructor_name,
        notes: er[5].strip
      }
    end

    {
      protocol_number: text.match(/ПРОТОКОЛ № (\d+)/)[1],
      examiner_name: text.match(/ПРЕДСЕДАТЕЛ:\s+([[:alpha:]]+\s+[[:alpha:]]+(\s+[[:alpha:]]+)?)/)[1],
      type: text.match(/ЗА\sПРОВЕЖДАНЕ\sНА\s+(ПРАКТИЧЕСКИ|ТЕОРЕТИЧЕН)(?=\sИЗПИТ\sЗА\sПРИДОБИВАНЕ)/)[1],
      results: results
    }
  end
end

source = ARGV[0]

text = File.open(source).read
date = text.match(/\d{2}\.\d{2}\.\d{4}/)[0]
json = split_by_municipalities text, date

puts json
