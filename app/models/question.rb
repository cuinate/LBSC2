class Question < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true
  has_many :answers
  scope :unanswered, where(:answers_count => '0')
  scope :by_placeID, lambda { |place_id| where("place_id = ?", place_id) } 

  def self.answers_sum(place_id)
    where(:place_id => place_id).
    select("sum(answers_count) as answers_sum")
  end
end
