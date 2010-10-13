class UsersController < ApplicationController
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if @user.save
      logger.info "saved!"
    else
      logger.info "failed"
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:notice] = 'failed to add new!'
        format.html { render :action => "new" }
       
      end
    end
  end


  def log_in
    e_mail = params[:e_mail]
    logger.info("e_mail in  paramters -->" +params[:e_mail])
    logger.info("password in  paramters -->" +params[:password])
    password = params[:password]
    user = User.find_by_e_mail(e_mail)
     if user 
        user = User.authenticate(e_mail,password)
        if user
          session[:user_id] = user.id
          flash[:notice] = "susscusslly log-in!"
        else
          flash[:notice] = "password wrong, please try again!"
        end 
          
    else
        flash[:notice] = 'user does not exist!'
   end 
      respond_to do |format|
        format.html {render :nothing => true}
     end
  end
end
