module ApplicationHelper

# Returns true if the user is logged in as an administrator.
  def admin_user?
  	if current_user.nil?
  		false
  	else
  		current_user.admin?
  	end
  end

end
