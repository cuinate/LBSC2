class PlacesController < ApplicationController
  
  
#SP3-2.1 
# { Type: 1~4, paras: name or blank}
def show
  show_type = params[:type]
  show_para = params[:paras]
  logger.info(show_type)
  
  if show_type == "1"
        # find by name 
        @place = Place.find(:all, :conditions =>["name LIKE?", "%#{show_para}%"])
  elsif show_type == "2"
       # find by id
  elsif show_type == "3"
       #find by hot 
       item_limit = 20
       @place = Place.order('places.questions_count DESC').limit(item_limit)
       hot_place = Array.new
       i = 0 
       @place.each do |p|
         place_hash = Hash.new
         place_hash["place_id"] = p.id
         place_hash["place_name"] = p.name
         place_hash["latitude"] = p.latitude
         place_hash["longtitude"]= p.longtitude
         place_hash["questions_count"] = p.questions_count
         place_hash["activities_count"] = p.activities_count
         place_hash["unanswered_count"] = p.questions.unanswered.size()
         hot_place[i] = place_hash
         i = i + 1
       end
       # -- get the unanswered the questions number. 
      # hot_place = place.select()
      # @place = Place.find(:all, :limit => item_limit, :order =>"questions_count DESC")
  else 4
        place = nil
  end
  
  if @place
    if show_type == "3"
      render :json => hot_place.to_json
    else
    render :json => @place.to_json
    end
  else 
     m_result ={
      :result => "0"
      }
    render :json => m_result.to_json
  end
end 
#SP3-3.1
def create
 
    @place = Place.new
    @place.name = params[:name]
    @place.address = params[:address]
    @place.latitude = params[:latitude]  
    @place.longtitude = params[:longtitude]
    @place.city = params[:city]  
    @place.user_id = session[:user_id]
    
     if @place.save!
        flash[:notice] = 'Challenge was successfully created.'
         redirect_to "/"
     else
        flash[:notice] = 'Challenge was failed to be created.'
        redirect_to "/"
    end
end

end
