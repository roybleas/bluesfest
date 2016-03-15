# == Schema Information
#
# Table name: artists
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  linkid      :string
#  active      :boolean          default(FALSE)
#  extractdate :date
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ArtistsController < ApplicationController
	include Artistpages

  def index
  	redirect_to artistsbypage_path("a")
  end

  def show
  	artist_id = params[:id].to_i
  	
  	@artist = Artist.find_by_id(artist_id)  	
  	
  	if @artist.nil?
  		redirect_to artistsbypage_path("a") 
  	else
	  	@performances = Performance.for_artist(artist_id).includes(:stage).all 
	  	festival = Festival.find_by_id(@artist.festival_id)
	  	@startdate_minus_one = (festival.startdate - 1) unless festival.nil?
	  	if logged_in?
	  		@favourite_artist = Favourite.find_by(artist_id: @artist.id, user_id: current_user.id)
	  	end
  	end
  end
  
  def bypage
  	
  	letter = params[:letter]
  	user_id = logged_in? ? @current_user.id : 0

  	
  	create_artists_list_by_page(letter,user_id)
		
		@favourites_style = :as_glypicon
	end
	
	private

	
end
