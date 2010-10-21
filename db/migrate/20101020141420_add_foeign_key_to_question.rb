class AddFoeignKeyToQuestion < ActiveRecord::Migration
  def self.up
    add_foreign_key(:questions, :places)
  end

  def self.down
    remove_foreign_key(:questions)
  end
end
