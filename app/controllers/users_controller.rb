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
  
  def past_list
    if session[:user_id] == User.find_by_username(params[:username]).id
      @past_list = User.find_by_username(params[:username]).past_courses.sort_by(&:downcase)
    else
      redirect_to :root
    end
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
      if user_params.has_key?('first_name')
	      redirect_to profile_path(@user.username), alert: "Succesfully updated!"
      elsif user_params.has_key?('past_courses')
        redirect_to :back, alert: "Succesfully updated past courses!"
      
      elsif user_params.has_key?('current_courses')
        redirect_to :back, alert: "Succesfully updated cart!"
      
      elsif user_params.has_key?('friend_ids')
        redirect_to :back, alert: "Updated friends list!"
      end
    else
      render 'edit'
    end
  end
  
  def new
    if !session[:user_id].nil?
      redirect_to :root
    else
      @user = User.new
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to action: 'profile', username: @user.username
    else
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
	  if session[:user_id].nil?
	    redirect_to :root
	  else
	    @user = User.find_by_username(params[:username])
	  end
	end
	
  private
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, {:past_courses => []}, :address, {:friend_ids => []}, {:current_courses => []}, :password, :password_confirmation, :major, :avatar_id)
  end
  
end
