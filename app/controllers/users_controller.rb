class UsersController < ApplicationController
  
  def profile
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
        redirect_to @user
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
      redirect_to action: 'profile', id: @user.id
        else
            render 'new'
        end
  end
  
  def schedule
    
  end
  
  def cart
    
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :past_courses, :address, :friend_ids, :current_courses, :password)
  end
  
end
