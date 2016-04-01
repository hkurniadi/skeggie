class UsersController < ApplicationController
  
  def profile
		
		if !User.exists?(username: params[:username])
		  redirect_to :root
		else
		  @user = User.find_by_username(params[:username])
		end
  end
  
  def show
		@user = User.find(params[:id])
  end
  
  def edit
    
    if !User.exists?(username: params[:username])
      redirect_to :root
    else
      @user = User.find_by_username(params[:username])
      if !(session[:user_id] == @user.id)
        redirect_to :root
      end
    end
  end
  
  def update
    @user = current_user
    if @user.update(user_params)
	    redirect_to :back, alert: "Succesfully updated."
    else
      render 'edit'
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to action: 'profile', username: @user.username
    else
      flash.now[:alert] = "Username already taken, please enter a different username."
      render 'new'
    end
  end
  
  def schedule
		@current_courses = User.find_by_username(params[:username]).current_courses
  end
  
  def cart
    if session[:user_id].nil?
      redirect_to :root
    end
  end
  
	def search
		@user = User.all
	end
	
	def major_reqs
	  @user = User.find_by_username(params[:username])
	end
	
  private
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, {:past_courses => []}, :address, {:friend_ids => []}, {:current_courses => []}, :password, :password_confirmation, :major)
  end
  
end
