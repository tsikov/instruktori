class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :protocol
      t.date :date
      t.string :examiner
      t.integer :kind

      t.timestamps null: false
    end
  end
end
