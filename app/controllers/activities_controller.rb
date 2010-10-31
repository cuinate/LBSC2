class ActivitiesController < ApplicationController
  protect_from_forgery :except =>[:create]
  before_filter :require_user
  
# ajax post to create activity
# action_id meanings:
# 0 :: checkin ; 1:: ask question ;2:: answer 3:: vote up ; 4:: vote down ; 5::follow place 6::follow question 
# 7 :: remove place followship  8 ::remove question followship
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
    
    result      = Array.new
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
         result_hash = {
           :result => 1
           }
         result.push(result_hash)
         result_hash = {
            :answer_id => answer.id
            }
        result.push(result_hash)
       else 
         result_hash = {
            :result => 0
            }
          result.push(result_hash)
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
            result_hash = {
              :result => 1
              }
            result.push(result_hash)
            result_hash = {
               :question_id => question.id
               }
           result.push(result_hash)
        else
          result_hash = {
             :result => 0
             }
           result.push(result_hash)
 
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
          when "5" # follow places
              @followship = current_user.followships.build(:place_id => place_id)
              @followship.save
          when "6" # follow questions
            @qfollowship = current_user.qfollowships.build(:question_id => question_id)
            @qfollowship.save
        #  when "6" # follow questions
          when "7" # remove place followship
              @followship = current_user.followships.find_by_place_id(place_id)
              Followship.destroy(@followship.id)
          when "8" # remove quesiton followship
              @qfollowship = current_user.qfollowships.find_by_question_id(question_id)
              Qfollowship.destroy(@qfollowship.id)
           
       end  # save those acivities into activity table
          if @activity.save!
            result_hash = {
               :result => 1
               }
             result.push(result_hash)
            
          else 
             result_hash = {
                :result => 0
                }
              result.push(result_hash)
              
          end
   end 
    render :json => result
  end 
end
