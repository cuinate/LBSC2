class QuestionsController < ApplicationController
  def create

      @question = Question.new
      @question.place_id = params[:place_id]
      @question.description = params[:description]
      @question.points = params[:points]
      @question.user_id = session[:user_id]
      

       if @question.save!
          flash[:notice] = 'quesitons was successfully created.'
           redirect_to "/"
       else
          flash[:notice] = 'quesitons was failed to be created.'
          redirect_to "/"
      end
  end
#SP12-1 hot search based on "city name"?

  def hot
    items_limit = 20
    @questions_hot =  Question.order('answers_count DESC , place_id').limit(items_limit)
    @hot_questions = Array.new
    
    if @questions_hot
      question_to_hash(@hot_questions,@questions_hot)
       
    else
       m_result ={
         :result => 0
         }
      hot_questions[0] = m_result
    end
    
    
    #SP11-2.1 Place hot
    respond_to do |format|
      format.html # hot.html.erb
      format.json { render :json => @hot_questions}
    end
    
  end
  
#SP10-2.1 convert place result into hash array
  def question_to_hash(hash_array,question)
         m_result ={
           :result => 1
           }
        hash_array[0] = m_result
        
        i = 1  # hash_arry index
        j = 0  # questions hash arry index
        place_id = question.first.place_id
         
        questions = Array.new
        result_hash = Hash.new
       
       question.each do |q|
          
          if (place_id != q.place_id)
            result_hash["place_id"] = place_id
            place_id = q.place_id
            
            result_hash["questions"] = questions
            hash_array[i] = result_hash       
           
            i = i + 1   
            j = 0
            result_hash = Hash.new
            questions = Array.new
          end
          
          result_hash["place_name"] = q.place.name
          
          question_hash = Hash.new
          question_hash["description"] = q.description
          question_hash["question_id"] = q.id
          question_hash["answers_count"] = q.answers_count
          question_hash["votes_sum"] = q.answers.votes_sum.first.votes_sum.to_i
          
          questions[j] = question_hash
          j = j + 1
          
          if (question.last)
            result_hash["place_id"] = place_id
            result_hash["questions"] = questions
            hash_array[i] = result_hash
          end
         
     end
  end

end
