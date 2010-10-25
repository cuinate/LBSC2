class Answer < ActiveRecord::Base
  belongs_to :question,  :counter_cache => true
 
  
  def self.votes_sum(question_id)
     where(:place_id => question_id).
     select("sum(up_counts) + sum(down_counts) as votes_sum")
   end
   
end
