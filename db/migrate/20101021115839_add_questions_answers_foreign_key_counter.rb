class AddQuestionsAnswersForeignKeyCounter < ActiveRecord::Migration
  def self.up
    add_foreign_key(:answers, :questions) 
    add_column :questions, :answers_count, :integer ,:default => 0
    Question.find(:all).each do |s|
      Question.update_counters s.id, :answers_count => s.answers.length
    end
  end
  def self.down
    remove_column :questions, :answers_count
    remove_foreign_key(:answers)
  end
end
