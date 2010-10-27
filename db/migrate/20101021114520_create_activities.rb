class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.integer :place_id , :default => 0
      t.integer :question_id , :default => 0
      t.integer :answer_id , :default => 0
      t.integer :action_id 

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
