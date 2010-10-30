class RemoveFollowshipQuesitonId < ActiveRecord::Migration
  def self.up
    remove_column:followships, :question_id
  end

  def self.down
    add_column :followships, :question_id, :integer, :default => 0
  end
end
