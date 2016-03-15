class HomePagesController < ApplicationController
   def home
  	
  	
  	Time.zone ="Sydney"
  	
  	@localTime = Time.current
  	
  	today = @localTime.to_date
  	
  	@festival = Festival.current_active.take
  	if @festival.nil?
  		#set for missing festival
  		@days2go = ""
  		
  	else
  		festivaldate = @festival.startdate
  		days = (festivaldate - today).to_i
  		if days <= 0 and days && days > (@festival.days * -1)
  			redirect_to plan4today_url 
  		elsif days < (@festival.days * -1)
  			@days2go = "It's over for this year see you next year"
  		elsif days == 1
  			@days2go = "Starts tomorrow!!"
  		else
  			@days2go = "Only #{days} days to go!"
  		end
  	end
  end

  def plan
  end

  def now
  end

  def next
  end
end
