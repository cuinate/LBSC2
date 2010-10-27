class Answer < ActiveRecord::Base
  belongs_to :question,  :counter_cache => true
  has_many :activities, :class_name => "Activity", :foreign_key => "answer_id"
#  scope :votes_sum, select("sum(up_counts) + sum(down_counts) as votes_sum")
 
#SP12-1 votes sum for one associated questions
  def self.votes_sum
     select("sum(up_counts) + sum(down_counts) as votes_sum")
   end
   
end
