class PlacesController < ApplicationController
  before_filter :require_user, :only => [:followed,:create]
  
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
          when "hot_question"
             @place = Place.find(id)
             @questions =  @place.questions.order("answers_count DESC")
          when "place_activities"
             @place = Place.find(id)
             @activites =  @place.activities.order("created_at DESC")
          else
             @place = Place.find(id)
             @questions =  @place.questions.order("created_at DESC")
        end 
        # convert question to json
        if @questions
          q_hash_array = Array.new
          question_to_hash(q_hash_array,@questions)
        else 
          m_result = Hash.new
          m_result["result"] = 0
          q_hash_arry = m_result
        end
          
        respond_to do |format|
          format.html # show.html.erb
          format.json { render :json => q_hash_array}
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
                m_result = Hash.new
                m_result["result"] = 1
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
#SP10-2.1 followed places by user
      def followed
       
#        user_id = params[:user_id]
#        if !user_id 
#          user_id = session[:user_id]
#        end
        
        tagged_places_id = current_user.followships.place_id
        #Activity.one_user(user_id).tagged_place.place_id
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
          render :json => tagged_place_hash
        else
            result = Array.new
            result_hash = {
              :result => 0
              }
            result.push(result_hash)
          render :json => result
        end
           
      end 
#SP10-2.1 find nearby place 
      def nearby
            items_limit = 10
            current_lat = params[:lat].to_f
            current_lng = params[:lng].to_f
            @place_nearby = Place.show_place_nearby(current_lat,current_lng,items_limit)
            nearby_place = Array.new
            place_to_hash(nearby_place,@place_nearby)
             logger.info("[nearby]hash_array = _________#{nearby_place}")
            render :json => nearby_place.to_json
      end
#SP10-2.1 convert place result into hash array
      def place_to_hash(hash_array,place)
            logger.info("[place_to_hash] :: place = _________#{place.first}")
             m_result = Hash.new
             m_result["result"] = 0
            if place.first
              logger.info("[place_if]m_result = _________#{m_result}")
              m_result["result"] = 1
              i = 0 
              hash_array[i] = m_result
              i = i + 1
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
           else
            logger.info("m_result = _________#{m_result}")
              hash_array[0] = m_result
            logger.info("hash_array = _________#{hash_array}")
           end
          
      end
#SP11－3 place-questions view (question to hash)
      def question_to_hash(hash_array,question)
     
            m_result = Hash.new
            m_result["result"] = 1
           i = 0 
           hash_array[i] = m_result
           i = i + 1
           question.each do |q|
               question_hash = Hash.new
               question_hash["description"] = q.description
               question_hash["question_id"] = q.id
               question_hash["answers_count"] = q.answers_count
               question_hash["votes_sum"] = q.answers.votes_sum.first.votes_sum.to_i
         
               hash_array[i] = question_hash
           i = i + 1
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
              m_result = Hash.new
              m_result["result"] =1
              m_result["place_id"] = @place.id
              m_result["name"] = @place.name
               
           else
              flash[:notice] = 'Challenge was failed to be created.'
              m_result = Hash.new
              m_result["result"] = 0
          end
          respond_to do |format|
            format.html { redirect_to "/"}
            format.json { render :json => m_result}
          end
      end

end
