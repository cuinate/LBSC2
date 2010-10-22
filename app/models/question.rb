class Question < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true
  has_many :answers
end
