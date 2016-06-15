module Userlogin
  extend ActiveSupport::Concern
  
  #before filters
	def logged_in_user
		unless logged_in?
			flash[:danger] = "Please log in"
			redirect_to login_url
		end
	end
  
  # Confirms the admin user.
 def admin_user
       
    unless current_user.admin?
    	flash[:danger] = "Please log in with the correct user name."
    	redirect_to(root_url)
    end
 end

end