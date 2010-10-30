class Followship < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  scope :place_id, select("place_id")
end
