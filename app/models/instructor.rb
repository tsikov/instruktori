class Instructor < ActiveRecord::Base

  has_many :results
  self.per_page = 10

  def self.text_search(instructor_name)
    if instructor_name.present?
      where("name @@ :q", q: instructor_name)
    else
      all
    end
  end

end
