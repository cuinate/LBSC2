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
       @place = Place.find(:all, :limit => item_limit, :order =>"questions_count DESC")
  else 4
        place = nil
  end
  
  if @place
    render :json => @place.to_json
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
