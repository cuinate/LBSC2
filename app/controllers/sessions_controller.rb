
class SessionsController < ApplicationController
  def new
  end

  def create
    
    current_user = User.authenticate(params[:login], params[:password])
    if current_user
        self.current_user = current_user

        # Remember me functionality
        new_cookie_flag = (params[:remember_me] == "on")

        handle_remember_cookie! new_cookie_flag

        flash[:notice] = "Logged in successfully."
 #       session[:user_id] = current_user.id
       redirect_back_or_default("/")
#        redirect_to "/"
   else
        logout_killing_session!
        flash.now[:error] = "Invalid login or password."
        render :action => 'new'
    end
 end      
#---- SP1-6.4 :: login the mobile user 
  def m_create
    user = User.authenticate(params[:login], params[:password])   
    if user
      user.check_m_token
      m_result = {
      :result => "1",
      :u_id   => user.id,
      :m_token => user.m_token
      }  
    session[:user_id] = user.id
    else
      m_result ={
      :result => "0"
      }
   end 
   render :json => m_result.to_json
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to "/"
  end
end
