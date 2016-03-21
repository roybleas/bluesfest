class HomePagesController < ApplicationController
   def home
  	
  	Time.zone ="Sydney"
 
  	@localTime = Time.current
  	
  	@localTime = getTestTime unless session[:test_time].nil?
  	
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
					@festivaldays = @festival.days
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
  	Time.zone ="Sydney"

  	@localTime = Time.current
  	
  	@localTime = getTestTime unless session[:test_time].nil?
  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %H:%M")

		today = @localTime.to_date
		
		festival = Festival.current_active.take
		if festival.nil?
			@performances = []
		else 
			@dayindex = get_dayindex(festival,today)
			if @dayindex > 0 and  @dayindex <  festival.days
				maxstarttime = @localTime.strftime("%H:%M")
			
				@performances = get_now_performances(@dayindex,maxstarttime,festival)
			else
				@dayindex = 0
				@performances = []
			end
		end
  end

  def next
   	Time.zone ="Sydney"

  	@localTime = Time.current
  	
  	@localTime = getTestTime unless session[:test_time].nil?
  	
  	@localTime_caption = @localTime.strftime("%a %d %b %Y %H:%M")

		today = @localTime.to_date
		
		festival = Festival.current_active.take
		if festival.nil?
			@performances = []
		else 
			@dayindex = get_dayindex(festival,today)
			if @dayindex > 0 and  @dayindex <  festival.days
				minstarttime = @localTime.strftime("%H:%M")
				@performances = get_next_performances(@dayindex,minstarttime,festival)
			else
				@dayindex = 0
				@performances = []
			end
		end

  end
  
  private
  
  def getTestTime
  	Time.zone ="Sydney"
  	
  	if session[:test_time].nil?
  		testTime = Time.current
  	else
  		testTime = session[:test_time].to_datetime
  	end
  	
  	return testTime
  end
 
 	def get_now_performances(dayindex, maxstarttime, festival)
 		
		sub_query = Performance.select("stage_id, max(starttime) as start_time").where("daynumber = ? and starttime  <= ?",dayindex, maxstarttime ).group("stage_id")

		main_query = Performance.select("performances.duration,performances.starttime,performances.title as caption, artist_id, stages.id, stages.code,stages.title").from(sub_query,:p1).joins(" inner join performances on p1.stage_id = performances.stage_id and p1.start_time = performances.starttime inner join stages on stages.id = performances.stage_id").joins( " inner join artists on artists.id = performances.artist_id" ).where("performances.daynumber = ? and performances.festival_id = ?", dayindex, festival.id).order("stages.seq")

		return main_query
	end
	
	def get_next_performances(dayindex, minstarttime, festival)
 		
		sub_query = Performance.select("stage_id, min(starttime) as start_time").where("daynumber = ? and starttime  > ?",dayindex, minstarttime ).group("stage_id")

		main_query = Performance.select("performances.duration,performances.starttime,performances.title as caption, artist_id, stages.code,stages.title").from(sub_query,:p1).joins(" inner join performances on p1.stage_id = performances.stage_id and p1.start_time = performances.starttime inner join stages on stages.id = performances.stage_id").where("performances.daynumber = ? and performances.festival_id = ?", dayindex, festival.id).order("stages.seq")
	
		return main_query
	end
	
	def get_dayindex(festival, today)
		festivaldate = festival.startdate
		days = (festivaldate - today).to_i
		if days <= 0 and  days > (festival.days * -1)
			return (days * -1) + 1
		else
			return	0
		end
	end
end
