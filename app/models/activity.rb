class Activity < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true 
  scope :one_user, lambda { |user_id| where("user_id = ?", user_id) } 
  scope :tagged_place, where(:action_id => 7)
  scope :place_id, select("place_id")
end

