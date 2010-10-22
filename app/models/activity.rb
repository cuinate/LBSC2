class Activity < ActiveRecord::Base
  belongs_to :place,  :counter_cache => true 
end
