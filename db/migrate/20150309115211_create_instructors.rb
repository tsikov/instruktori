class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :name
      t.string :city
      t.string :address
      t.string :phone
      t.string :categories, array: true
      t.string :province
      t.integer :permit
      t.float :score

      t.timestamps null: false
    end
  end
end
