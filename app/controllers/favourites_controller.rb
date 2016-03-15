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
    letter = params[:letter]
  	user_id = @current_user.id 

  	create_artists_list_by_page(letter,user_id)
  	
  	@favourites_style = :as_link
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
  
end