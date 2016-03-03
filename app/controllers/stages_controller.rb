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
	include Validations
	
  def index
  	
  	festival = Festival.current_active.take
  	getStageSelectValues(festival)
  end

  def show
  	stage_id = params[:id].to_i
  	dayindex = params[:dayindex].to_i
  	
  	Time.zone ="Sydney"
  	
  	festival = Festival.current_active.take
  	getStageSelectValues(festival)
  	
  	@dayindex = valid_dayindex(festival,dayindex)
  	@previousdayindex = previous_dayindex(festival,dayindex)
  	@nextdayindex = next_dayindex(festival,dayindex)
  	@dayofweek = valid_dayofweek(festival,@dayindex)
  
  	@stage = Stage.current_active_festival.find_by_id(stage_id)
  	@previousstage = previous_stage(@stages,@stage)
  	@nextstage = next_stage(@stages,@stage)
  	@performances = Performance.for_stage(stage_id).for_day(dayindex).includes(:artist).order(starttime: :desc).all
  end
  
  private
  def getStageSelectValues(festival)
  	if festival.nil?
  		@stages = []
  		@days = 0
  	else
  		@days = festival.days
  		@stages = Stage.by_festival(festival).order(seq: :asc).all
  	end
	end  
end
