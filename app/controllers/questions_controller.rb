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
end
