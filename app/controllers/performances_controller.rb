# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  daynumber       :integer
#  duration        :string
#  starttime       :time
#  title           :string
#  scheduleversion :string
#  festival_id     :integer
#  artist_id       :integer
#  stage_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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
  		@performances = Performance.for_day(@dayindex).includes(:artist, :stage).for_festival(festival).order(starttime: :asc).all
  		@stages = Stage.by_festival(festival).order(seq: :asc).all
  		@performancedate = (festival.startdate + @dayindex - 1).strftime("( %a %d %B %Y )")
  	end
  end
end
