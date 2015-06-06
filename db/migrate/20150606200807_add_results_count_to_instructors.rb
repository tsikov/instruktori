class AddResultsCountToInstructors < ActiveRecord::Migration
    def self.up
    add_column :instructors, :results_count, :integer, :default => 0

    Instructor.all.each do |p|
      p.update_attribute :results_count, p.results.count
    end
  end

  def self.down
    remove_column :instructors, :results_count
  end
end
