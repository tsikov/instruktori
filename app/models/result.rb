class Result < ActiveRecord::Base
  belongs_to :exam
  belongs_to :instructor

  enum results: [:yes, :no, :absent, :unadmitted]

  self.per_page = 100

end
