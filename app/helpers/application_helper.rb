module ApplicationHelper

# Returns true if the user is logged in as an administrator.
  def admin_user?
  	if current_user.nil?
  		false
  	else
  		current_user.admin?
  	end
  end

	def festival_title
		festival = Festival.current_active.take
		title = festival.nil? ? "Festival not set" : "#{festival.title} #{festival.year}"
		return title
	end
end
