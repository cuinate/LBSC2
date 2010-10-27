class PlacesController < ApplicationController
  
      def show 
        @place = Place.find(params[:id])
        @questions =  @place.questions.order("created_at DESC")
        
          logger.info("====== questions #{@questions}")
        
         respond_to do |format|
          format.html # show.html.erb
        end
      end
#SP3-2.1 
# { Type: 1~4, paras: name or blank}

      def show_place
        id = params[:id]
        type = params[:type]
        # type 
        # 1: newest questions
        # 2: open questions
        # 3: hot questions
        # 4: place activites
        case type 
          when "new_question"
             @place = Place.find(id)
             @questions =  @place.questions.order("created_at DESC")
          when "open_question"
             @place = Place.find(id)
             @questions =  @place.questions.unanswered.order("created_at DESC")
              logger.info("====== question type====> #{type}")
              logger.info("====== questions #{@questions}")
          when "3"
          when "place_activities"
             @place = Place.find(id)
             @activites =  @place.activities.order("created_at DESC")
          else
             @place = Place.find(id)
             @questions =  @place.questions.order("created_at DESC")
        end 
       
        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => @place}
          format.js
        end
       
      end 
#SP10-2.1 places like the name :
      def like 
            show_para = params[:paras]
            logger.info(show_para)
            # find by name 
            @place = Place.where("name LIKE?", "%#{show_para}%").order('places.questions_count DESC')
            if @place
              render :json => @place.to_json
            else 
                 m_result ={
                  :result => "0"
                  }
                render :json => m_result.to_json
           end 
      end
#SP10-2.1 hot place action
      def hot
            items_limit = 20
            @place_hot =  Place.order('places.questions_count DESC').limit(items_limit)
            hot_place = Array.new
            place_to_hash(hot_place,@place_hot)
            
            #SP11-2.1 Place hot
            respond_to do |format|
              format.html # hot.html.erb
              format.json { render :json => hot_place}
            end

      
      end
#SP10-2.1 Tagged places by user
      def tagged
        user_id = params[:user_id]
        if !user_id 
          user_id = session[:user_id]
        end
        
        tagged_places_id = Activity.one_user(user_id).tagged_place.place_id
        tagged_places = Array.new  # to save the place result
        tagged_place_hash = Array.new # to save the place + answers hash
        i = 0
        
        if tagged_places_id
          tagged_places_id.each do |p|
            tagged_places[i] = Place.find(p.place_id)
            i = i + 1
          end
          
          place_to_hash(tagged_place_hash,tagged_places)
        end
        
        if tagged_place_hash.size() 
          render :json => tagged_place_hash.to_json
        else
           m_result ={
            :result => "0"
            }
          render :json => m_result.to_json
        end
           
      end 
#SP10-2.1 convert place result into hash array
      def place_to_hash(hash_array,place)
           i = 0 
           place.each do |p|
               place_hash = Hash.new
               place_hash["place_id"] = p.id
               place_hash["place_name"] = p.name
               place_hash["place_address"] = p.address
               place_hash["latitude"] = p.latitude
               place_hash["longtitude"]= p.longtitude
               place_hash["questions_count"] = p.questions_count
               place_hash["activities_count"] = p.activities_count
               place_hash["unanswered_count"] = p.questions.unanswered.size()
               hash_array[i] = place_hash
           i = i + 1
           end
      end

#SP10-2.1 find nearby place 
      def nearby
            items_limit = 10
            current_lat = params[:lat].to_f
            current_lng = params[:lng].to_f
            place_nearby = Place.show_place_nearby(current_lat,current_lng,items_limit)
            nearby_place = Array.new
            place_to_hash(nearby_place,place_nearby)
            render :json => nearby_place.to_json
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
