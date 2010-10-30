class Qfollowship < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  scope :question_id, select("question_id")
end
