class AddPlaceQuestionCounter < ActiveRecord::Migration
  def self.up
    add_column :places, :questions_count, :integer ,:default => 0
    Place.find(:all).each do |s|
      Place.update_counters s.id, :questions_count => s.questions.length
    end
  end

  def self.down
    remove_column :places, :questions_count
  end
end
