# == Schema Information
#
# Table name: stages
#
#  id          :integer          not null, primary key
#  title       :string
#  code        :string(2)
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class StagesController < ApplicationController
  def index
  	
  	festival = Festival.current_active.take
  	if festival.nil?
  		@stages = []
  		@days = 0
  	else
  		@days = festival.days
  		@stages = Stage.current_active_festival.order(seq: :asc).all
  	end
  end

  def show
  	stage_id = params[:id].to_i
  	dayindex = params[:dayindex].to_i
  	
  	Time.zone ="Sydney"
  	
  	festival = Festival.current_active.take
  	
  	if festival.nil?
  		@dayindex = 0 
  	else
  		@dayindex = dayindex > festival.days ? festival.days : dayindex
  		@dayindex = 1 if dayindex < 1
  		if !festival.startdate.nil?
  			startdate = festival.startdate + (@dayindex - 1)
  			@dayofweek = startdate.strftime("%a %d %b") 
  		end
  	end
  	
  	@stage = Stage.current_active_festival.find_by_id(stage_id)
  end
end
