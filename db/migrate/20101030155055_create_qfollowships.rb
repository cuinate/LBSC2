class CreateQfollowships < ActiveRecord::Migration
  def self.up
    create_table :qfollowships do |t|
      t.integer :question_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :qfollowships
  end
end
