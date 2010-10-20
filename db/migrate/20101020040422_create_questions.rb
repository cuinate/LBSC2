class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :place_id
      t.string   :description
      t.integer  :points
      t.integer  :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
