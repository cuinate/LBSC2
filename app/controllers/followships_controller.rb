class FollowshipsController < ApplicationController
  def create
    place_id     = params[:place_id]
    @followship = current_user.followships.build(:place_id => place_id)
    if @followship.save
      render :text => 1
    else
      render :text => 0
    end 
  end
end
