class AddPlaceActivitiesCount < ActiveRecord::Migration
  def self.up
    add_column :places, :activities_count, :integer ,:default => 0
    Place.find(:all).each do |s|
      Place.update_counters s.id, :activities_count => s.activities.length
    end
  end

  def self.down
    remove_column :places, :activities_count
  end
end
