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

end
