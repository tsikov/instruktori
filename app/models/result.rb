class Result < ActiveRecord::Base
  belongs_to :exam
  belongs_to :instructor, dependent: :destroy, counter_cache: true

  enum results: [:yes, :no, :absent, :unadmitted]

  self.per_page = 100

end
