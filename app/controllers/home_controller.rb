class HomeController < ApplicationController
 # before_filter :require_user, :only => [ :index]
  def index
    respond_to do |format|
      format.html # show.html.erb
      format.mobi { render :layout => false }
    end
  end 
end
