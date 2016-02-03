class StaticPagesController < ApplicationController
	def about
	  Time.zone ="Sydney"
  	
  	festival = Festival.current_active.take
  	if festival.nil?
  		#set for missing active festival
  		@version = "Unknown"
  		@scheduledate = "Unknown"
  		
  	else
  		@version = "#{festival.major}.#{festival.minor}"
  		@scheduledate = festival.scheduledate.in_time_zone.strftime("%d %B %Y")
  	end

	end
end
