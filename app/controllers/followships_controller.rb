class FollowshipsController < ApplicationController
  def create
    place_id     = params[:place_id]
    question_id  = params[:question_id]
    if place_id 
      @followship = current_user.followships.build(:place_id => place_id)
    else 
      @followship = current_user.followships.build(:question_id => question_id)
    end 
    if @followship.save
      render :text => 1
    else
      render :text => 0
    end 
  end
end
