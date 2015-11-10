class UsersController < ApplicationController
	include Userlogin
  before_action :logged_in_user, only: [:edit, :update, :show, :destroy, :index]
  before_action :correct_user,   only: [:edit, :show, :destroy]

  def new
  	@user = User.new
  end
  
  def edit
  	@user = User.find(params[:id])
	end
	def show
		@user = User.find(params[:id])
	end
	
  def create
  	@user = User.new(user_params)
  	if @user.save
  		log_in @user
  		flash[:success] = "Welcome"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    if current_user.admin?
    	redirect_to users_url
    else
    	redirect_to root_url
  	end
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  	@usercount = User.count
  	@admin = current_user.admin?  	
	end

	def update
		@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile updated"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end
  
  private 
  
  	def user_params
  		params.require(:user).permit(:name, :screen_name, :password, :password_confirmation)
  	end
  	
  	
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
     
      unless current_user?(@user) or current_user.admin?
      	flash[:danger] = "Please log in with the correct user name."
      	redirect_to(root_url)
      end
    end

end
