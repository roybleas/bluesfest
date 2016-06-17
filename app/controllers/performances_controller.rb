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
	include Userlogin
  before_action :logged_in_user, only: [:index]
  before_action :admin_user,     only: [:index]
  
	
	
  def showbyday
  	dayindex = params[:dayindex].to_i
  	  	
  	festival = Festival.current_active.first
  	@dayindex = valid_dayindex(festival,dayindex)
  	
  	if festival.nil?
  		@festivaldays = 0
  		@performances = []
  		@stages = []
  		@performancedate = ""
  	else
  		@festivaldays = festival.days
  		@performances = Performance.for_day(@dayindex).includes(:artist, :stage).for_festival(festival).order(starttime: :asc).order("stages.seq").all
  		@stages = Stage.by_festival(festival).order(seq: :asc).all
  		@performancedate = (festival.startdate + @dayindex - 1).strftime("( %a %d %B %Y )")
  	end
  end
  
  def index
		festival = Festival.current_active.first
		if festival.nil?
  		@performances = []
  		@performancecount = 0
  	else
  		@performances = Performance.for_festival(festival).includes(:artist, :stage).order(daynumber: :asc).order("stages.seq").order(starttime: :asc)
  		@performancecount = Performance.for_festival(festival).count
		end
	end
end
