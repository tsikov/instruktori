json.instructors @instructors, :id, :name, :city, :score, :categories, :created_at

json.instructors_count @instructors_count
json.pages_count (@instructors_count.to_f/Instructor.per_page).ceil
json.page @page

