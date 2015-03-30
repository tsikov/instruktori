class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :exam, index: true
      t.references :instructor, index: true
      t.integer :result
      t.string :student_name
      t.string :notes

      t.timestamps null: false
    end
    add_foreign_key :results, :exams
    add_foreign_key :results, :instructors
  end
end
