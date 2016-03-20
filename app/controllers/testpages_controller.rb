class TestpagesController < ApplicationController
  def settime
  	Time.zone ="Sydney"
  	dayindex = params[:day].to_i
  	hr = params[:hr].to_i
  	mins = params[:min].to_i
  	
  	@localTime = Time.current  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %I:%M %p")


  	festival = Festival.current_active.take
  	
  	@session_time_caption = ""
  	
  	if festival.nil?
  		
  		flash[:warning] = "No current active festival"  
  	else
  		
  		festivaldays = festival.days
  		
  		if (dayindex > 0 and dayindex <= festivaldays)
  			@dayindex = dayindex
  			this_date = festival.startdate + (dayindex - 1)
  		else
  			@dayindex = 0 
  			flash[:warning] = "Invalid day value - Festival days is #{festivaldays}"  
 			end
 		
 			if (hr > 23)
  			@hr = 0 
  			flash[:warning] = "Invalid hour value"  
 			else
				 @hr = hr 
 			end
 			if (mins > 59)
  			@mins = 0 
  			flash[:warning] = "Invalid minutes value"  
 			else
				 @mins = mins
 			end
			if !this_date.nil?
				session[:test_time] = Time.new(this_date.year,this_date.month,this_date.day,@hr,@mins)
			end
  	end
  	
  	@session_time_caption = session[:test_time].strftime("%a %d %b %Y %I:%M %p") unless session[:test_time].nil?
  	
  end

  def showtime
  	
  	Time.zone ="Sydney"
  	
  	@localTime = Time.current
  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %I:%M %p")

  	if session[:test_time].nil?
  		@test_time = nil
  	else
  		@test_time = session[:test_time].to_datetime
  		
  		@test_time_caption = @test_time.strftime("%a %d %b %Y %I:%M %p")
  	end
  	
  end
  
  def reset
  	Time.zone ="Sydney"
  	
  	session[:test_time] = nil
	  	
  	
  	@localTime = Time.current
  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %I:%M %p")

	end
end
