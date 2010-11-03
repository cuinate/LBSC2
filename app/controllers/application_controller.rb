# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_mobi_format
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :require_user, :current_user, :current_user=, :logged_in?, :authorized?,:question_to_hash,:is_mobile_request?
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password, :password_confirmation
  
  def logged_in?
    !!current_user
  end
  
  def current_user
    @current_user ||= (login_from_session || login_from_client || login_from_cookie) unless @current_user == false
  end
  
  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end
  
  # A stem for an authorization system  
  def authorized?(action = action_name, resource = nil)
    logged_in?
  end
      
  def require_user
    authorized? || access_denied
  end
  
  def access_denied
    respond_to do |format|
 #     format.html do
        store_location
        flash[:notice] = "You must be logged in to view this page"
        redirect_to new_session_url
#      end
      
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # Add any other API formats here. (Some browsers, notably IE6, send Accept: */* and trigger
      # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
      # for a workaround.)
#      format.any(:json, :xml) do
#        request_basic_http_authentication 'Web Password'
#      end
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
   # Called from #current_user. First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = User.find(session[:user_id]) if session[:user_id]
  end

  # Called from #current_user. Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    authenticate_with_http_basic do |login, password|
      self.current_user = User.authenticate(login, password)
    end
  end
  
  #SP1-6.4.4 authorize request from mobile client
  def login_from_client
    uid = params[:user_id]
    m_token = params[:m_token]
    self.current_user = User.m_authenticate(uid,m_token)
  end

   # Called from #current_user. Finaly, attempt to login by an expiring token in the cookie.
  # for the paranoid: we _should_ be storing user_token = hash(cookie_token, request IP)
  def login_from_cookie
    user = cookies[:auth_token] && User.find(:first, :conditions => {:remember_token => cookies[:auth_token]})
    if user && user.remember_token?
      self.current_user = user
      handle_remember_cookie! false # freshen cookie token (keeping date)
      self.current_user
    end
  end

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    # Kill server-side auth cookie
    @current_user.forget_me if @current_user.is_a? User
    @current_user = false # not logged in, and don't do it for me
    kill_remember_cookie! # Kill client-side auth cookie
    session[:user_id] = nil # keeps the session but kill our variable
    
    # explicitly kill any other session variables you set
  end

  # The session should only be reset at the tail end of a form POST --
  # otherwise the request forgery protection fails. It's only really necessary
  # when you cross quarantine (logged-out to logged-in).
  def logout_killing_session!
    logout_keeping_session!
    reset_session
  end

  #
  # Remember_me Tokens
  #
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  def valid_remember_cookie?
    return nil unless @current_user
    (@current_user.remember_token?) &&
    (cookies[:auth_token] == @current_user.remember_token)
  end

  # Refresh the cookie auth token if it exists, create it otherwise
  def handle_remember_cookie!(new_cookie_flag)
    return unless @current_user
    case
      when valid_remember_cookie? then @current_user.refresh_token # keeping same expiry date
      when new_cookie_flag then @current_user.remember_me
      else @current_user.forget_me
    end
    send_remember_cookie!
  end
  
  def kill_remember_cookie!
    cookies.delete :auth_token
  end
  
  def send_remember_cookie!
    cookies[:auth_token] = {
      :value => @current_user.remember_token,
    :expires => @current_user.remember_token_expires_at }
  end
  
  # -----------------------------------------------------#
  #     questions list to hash                           #
  # -----------------------------------------------------#
  def question_to_hash(hash_array,question)
         m_result ={
           :result => 1
           }
        hash_array[0] = m_result
        
        i = 1  # hash_arry index
        j = 0  # questions hash arry index
        place_id = question.first.place_id
         
        questions = Array.new
        result_hash = Hash.new
       
       question.each do |q|
          
          if (place_id != q.place_id)
            result_hash["place_id"] = place_id
            place_id = q.place_id
            
            result_hash["questions"] = questions
            hash_array[i] = result_hash       
           
            i = i + 1   
            j = 0
            result_hash = Hash.new
            questions = Array.new
          end
          
          result_hash["place_name"] = q.place.name
          
          question_hash = Hash.new
          question_hash["description"] = q.description
          question_hash["question_id"] = q.id
          question_hash["answers_count"] = q.answers_count
          question_hash["votes_sum"] = q.answers.votes_sum.first.votes_sum.to_i
          
          questions[j] = question_hash
          j = j + 1
          
          if (question.last)
            result_hash["place_id"] = place_id
            result_hash["questions"] = questions
            hash_array[i] = result_hash
          end
         
     end
  end
  # -----------------------------------------------------#
  #     mbile site related                               #
  # -----------------------------------------------------#


  def set_mobi_format
    if is_mobile_request?
      request.format = :mobi
    end
  end
  def is_mobile_request?
      request.user_agent =~ /(Mobile)/
  end
  
end