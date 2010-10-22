class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.string  :description
      t.integer :up_counts
      t.integer :down_counts 
      t.boolean :is_choosen, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
