class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.integer :place_id
      t.integer :question_id
      t.integer :answer_id
      t.integer :action_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
