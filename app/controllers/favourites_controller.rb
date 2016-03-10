class FavouritesController < ApplicationController
	include Userlogin
	include Artistpages
	include Validations
	
  before_action :logged_in_user, only: [:add, :index, :day]

  def index
  	@favourites = Favourite.for_user(@current_user).includes(:artist).order("artists.name").all
  	festival = Festival.current_active.take
  	@festivaldays = festival.days unless festival.nil?
  end

  def destroy
  	redirect_to root_url
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
		return Artist.with_user_favourites(user).by_festival(festival).order(name: :asc).all if page_range.nil?
		return Artist.artists_by_range(page_range).with_user_favourites(user).by_festival(festival).order(name: :asc).all 
	end	

end
