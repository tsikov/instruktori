class Instructor < ActiveRecord::Base

  has_many :results
  self.per_page = 10

end
