class GfollowshipsController < ApplicationController
  def create
    question_id     = params[:question_id]
    @qfollowship = current_user.qfollowships.build(:question_id => question_id)
    
    if @qfollowship.save
      render :text => 1
    else
      render :text => 0
    end 
  end
end
