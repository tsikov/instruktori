json.results @results, :instructor_id, :result, :student_name, :notes

json.results_count @results_count
json.pages_count (@results_count.to_f/Result.per_page).ceil
json.page @page


