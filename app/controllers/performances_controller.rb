class PerformancesController < ApplicationController
	include Validations
  def showbyday
  	dayindex = params[:dayindex].to_i
  	  	
  	festival = Festival.current_active.first
  	@dayindex = valid_dayindex(festival,dayindex)
  	
  	if festival.nil?
  		@days = 0
  		@performances = []
  		@stages = []
  		@performanceday = ""
  	else
  		@days = festival.days
  		@performances = Performance.for_day(@dayindex).includes(:artist).for_festival(festival).order(starttime: :asc).all
  		@stages = Stage.by_festival(festival).order(seq: :asc).all
  		@performancedate = (festival.startdate + @dayindex - 1).strftime("( %a %d %B %Y )")
  	end
  end
end
