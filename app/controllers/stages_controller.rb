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
  end

  def show
  	stage_id = params[:id].to_i
  	dayindex = params[:dayindex].to_i
  	
  	festival = Festival.current_active.take
  	
  	if festival.nil?
  		@dayindex = 0 
  	else
  		@dayindex = dayindex > festival.days ? festival.days : dayindex
  		@dayindex = 1 if dayindex < 1
  	end
  	
  	@stage = Stage.current_active_festival.find_by_id(stage_id)
  end
end
