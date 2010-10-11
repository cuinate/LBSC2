class ChangeUserScores < ActiveRecord::Migration
  def self.up
    change_column :users, :scores, :integer
  end

  def self.down
    change_column :users, :scores, :string
  end
end
