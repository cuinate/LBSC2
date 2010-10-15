class SessionsController < ApplicationController
  def new
  end

  def create
    
    user = User.authenticate(params[:login], params[:password])
    if user
        self.current_user = user

        # Remember me functionality
        new_cookie_flag = (params[:remember_me] == "1")

        handle_remember_cookie! new_cookie_flag

        flash[:notice] = "Logged in successfully."
       # redirect_back_or_default(dashboard_url)
        redirect_to "/"
  else
        logout_killing_session!
        flash.now[:error] = "Invalid login or password."
        render :action => 'new'
    end
        
    
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to "/"
  end
end
