# == Schema Information
#
# Table name: favourites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FavouritesController < ApplicationController
	include Userlogin
	include Artistpages
	include Validations
	
  before_action :logged_in_user, only: [:add, :index, :day, :destroy, :create, :performanceupdate ]

  def index
  	@favourites = Favourite.for_user(@current_user).includes(:artist).order("artists.name").all
  	festival = Festival.current_active.take
  	@festivaldays = festival.days unless festival.nil?
  end

  def destroy
  	favourite = Favourite.find_by_id(params[:id])
  	if favourite.nil? 
  		flash[:error] = "Favourite record not found [id: #{params[:id]}"
  	else
  		favourite.destroy
  	end
  	redirect_to :back
  end
  
  def create
  	artist_id = params[:id].to_i
  	
  	artist = Artist.find(artist_id)
  	performances = Performance.where(artist_id: artist.id)
  	  	
  	ActiveRecord::Base.transaction do
			favourite = artist.favourites.create(user_id: @current_user.id)
  	
  		performances.each do |performance| 
  			fp = favourite.favouriteperformances.create(performance_id: performance.id) 
  		end
  	 end
  
  	redirect_to :back
  
  rescue ActiveRecord::RecordNotUnique
    flash[:warning] = "Favourite already added."
    redirect_to :back
  	
  end
	
	def performanceupdate  
		favperform_id = params[:id].to_i
		
		favouriteperformance = Favouriteperformance.find(favperform_id)
		
		favouriteperformance.active = !favouriteperformance.active
		favouriteperformance.save
		
		redirect_to :back
	end

  def add
  	festival = Festival.current_active.take
  	
  	@page = range_page(params[:letter])
  	page_range = verify_range(@page)
  	@artists = get_artists_by_range(page_range,@current_user,festival)
  	@pages = Artistpage.current_active_festival.all.order(seq: :asc)
  end

  def day
  	dayindex = params[:dayindex].to_i
  	
		festival = Festival.current_active.first
  	@dayindex = valid_dayindex(festival,dayindex)
  	
  	if festival.nil?
  		@festivaldays = 0
  		@performances = []
  		@performancedate = ""
  	else
  		@festivaldays = festival.days
  		#@performances = ?
  		@performancedate = (festival.startdate + @dayindex - 1).strftime("( %a %d %B %Y )")
  	end
  		
  end
  
  private
 	def get_artists_by_range(page_range,user,festival)
		return Artist.with_user_favourites(user.id).by_festival(festival).order(name: :asc).all if page_range.nil?
		return Artist.artists_by_range(page_range).with_user_favourites(user.id).by_festival(festival).order(name: :asc).all 
	end	

end
