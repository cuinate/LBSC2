class CreateFollowships < ActiveRecord::Migration
  def self.up
    create_table :followships do |t|
      t.integer :place_id ,:default => 0
      t.integer :question_id ,:default => 0
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :followships
  end
end
