class Place < ActiveRecord::Base
  has_many :questions
  has_many :activities
  scope :name_address, select("name,address")
  def self.show_place_nearby(current_lat, current_lng,items_limit)
      
      # caculate the boundary of rectangle 
      lat_NE = current_lat + 5/111.0
      lng_NE = current_lng + 5/111.0
      lat_SW = current_lat - 5/111.0
      lng_SW = current_lng - 5/111.0

      # run query from place database 
      where("longtitude BETWEEN ? and ? and latitude BETWEEN ? and ?",lng_SW, lng_NE,lat_SW, lat_NE).order('places.questions_count DESC').limit(items_limit)
    
  end
end
