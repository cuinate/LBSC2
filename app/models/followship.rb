class Followship < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  scope :place_id, select("place_id")
  scope :question_id, select("question_id") 
end
