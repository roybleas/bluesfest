module Admin
  extend ActiveSupport::Concern
  
  def admin_user?
		if not logged_in?
			redirect_to login_url
		else
			unless current_user.admin? 
				flash[:danger] = "Only administrators allowed to edit."
				redirect_to root_url
			end
			return true
		end
	end
  
 end