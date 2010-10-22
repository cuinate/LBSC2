class Question < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true
  has_many :answers
  scope :unanswered, where(:answers_count => '0')
end
