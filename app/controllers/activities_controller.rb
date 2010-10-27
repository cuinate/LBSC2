class ActivitiesController < ApplicationController
  protect_from_forgery :except =>[:create]
  
# ajax post to create activity
# action_id meanings:
# 0 :: checkin ; 1:: ask question ;2:: answer 3:: vote up ; 4:: vote down ; 5::follow place 6::follow question 
# 1:: 
  def create 
    user_id     = params[:user_id]
    place_id    = params[:place_id]||0
    question_id = params[:question_id]||0
    action_id   = params[:action_id] 
    # vote up or down
    answer_id   = params[:answer_id] 
    # answer a question
    answer      = params[:answer]
    #----- question  -----
    question    = params[:question] 
    points      = params[:points]
    
    @activity = Activity.new
    @activity.user_id = user_id
    @activity.place_id = place_id
    @activity.question_id = question_id
    #----- answer one question
    case action_id 
     when "2"
      answer = Answer.new(:user_id => user_id,
                          :question_id => question_id,
                          :description => answer 
                          )
      answer.save
      @activity.action_id = action_id
      @activity.answer_id = answer.id
      
       if @activity.save!
         result ={
           :status => 1,
           :answer_id => answer.id
           }
       else 
          result = 0
       end
   # ----- ask one question
    when "1"
      # ----- should already check the user_scores before sending the question
      question = Question.new(:user_id      => user_id,
                              :description  => question,
                              :place_id     => place_id,
                              :points       => points )
      
      question.save  
      
       @activity.action_id = action_id
       @activity.question_id = question.id
       
       if @activity.save!
         result ={
            :status => 1,
            :question_id => question.id
            }
        else
          result = 0
        end
          
  # ---- other actions :vote, follow
    else
        @activity.action_id = action_id
        case action_id 
          when  "3" # vote up
            answer = Answer.find(answer_id)
            answer.up_counts = answer.up_counts + 1
            answer.save
          when  "4" # vote_down
            answer = Answer.find(answer_id)
            answer.down_counts = answer.down_counts + 1
            answer.save
       end  # follow .....
          if @activity.save!
            result = 1
          else 
            result = 0
          end
   end  
    render :json => result
  end 
end
