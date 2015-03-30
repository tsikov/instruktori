class Exam < ActiveRecord::Base

  has_many :results
  enum kinds: [:theory, :practice]

end
