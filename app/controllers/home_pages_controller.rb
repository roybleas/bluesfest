class HomePagesController < ApplicationController
   def home
  	
  	
  	Time.zone ="Sydney"
  	
  	@localTime = Time.current
  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %I:%M %p")
  	
  	today = @localTime.to_date
  	
  	@festival = Festival.current_active.take
  	if @festival.nil?
  		#set for missing festival
  		@days2go = ""
  		
  	else
  		festivaldate = @festival.startdate
  		days = (festivaldate - today).to_i
  		if days <= 0 and  days > (@festival.days * -1)
				if logged_in?
					@dayindex = (days * -1) + 1
					@performances  = Performance.by_day_and_favourite_user_id(@dayindex,@current_user.id).active_favourite_performance.eager_load(:stage, favouriteperformances: :favourite ).order("performances.starttime desc").all
  				render :plan
  			else
  				redirect_to now_path
  			end
  		elsif days < (@festival.days * -1)
  			@days2go = "It's over for this year see you next year"
  		elsif days == 1
  			@days2go = "Starts tomorrow!!"
  		else
  			@days2go = "Only #{days} days to go!"
  		end
  	end
  end


  def now
  end

  def next
  end
end
