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
  before_action :logged_in_user, only: [:index, :edit]
  before_action :admin_user,     only: [:index, :edit]
  
  
  
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
  
  def edit
    @performance = Performance.find(params[:id])
    @stages = Stage.current_active_festival
  end
  
  def update
    @performance = Performance.find(params[:id])
    
    if valid_performance_attributes?(params)
    
      if @performance.update_attributes(performance_params)
        flash[:success] = "Performance updated"
        redirect_to performances_url
      else
        @stages = Stage.current_active_festival
        render 'edit'
      end
    else
      @stages = Stage.current_active_festival
      render 'edit'
    end
  
  end

  private 
  
    def performance_params
      params.require(:performance).permit(:daynumber, :duration, :starttime, :title, :festival_id, :stage_id)
    end
    
    def valid_performance_attributes? (params)
      is_valid = false
            
      festival = Festival.find(params[:performance][:festival_id])
      if festival.nil?
        flash[:error] = "Invalid festival_id [#{params[:festival_id]}]"
      elsif invalid_daynumber?(festival.days, params[:performance][:daynumber].to_i)
        flash[:error] = "Invalid daynumber = #{params[:performance][:daynumber]} with festival days set to #{festival.days}"
      else
        is_valid = true
      end
      return is_valid
    end
    
    def invalid_daynumber?(days,daynumber)
      # -1 allows performance to be temporarliy removed from view
      if daynumber == -1
        return false
      elsif daynumber <= days && daynumber > 0
        return false
      else
        return true
      end
    end
        
end
