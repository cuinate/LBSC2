class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
     respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def show_user
    @user = User.find(params[:id])
     respond_to do |format|
#      format.html # show.html.erb
      format.js
    end
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to "/"
    else

      render :action => 'new'
    end
  end
end
