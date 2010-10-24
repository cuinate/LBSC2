class Activity < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true 
  belongs_to :user
  scope :one_user, lambda { |user_id| where("user_id = ?", user_id) } 
  scope :one_place, lambda { |place_id| where("place_id = ?", place_id) } 
  scope :tagged_place, where(:action_id => 7)
  scope :place_id, select("place_id")
  scope :user_id, select("user_id")
end

