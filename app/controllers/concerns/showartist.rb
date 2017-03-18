module Showartist
	extend ActiveSupport::Concern
	
	def get_artist_performances(artist)
		@performances = Performance.for_artist(artist.id).where('daynumber > -1').includes(:stage).all 
	  festival = Festival.find_by_id(artist.festival_id)
	  @startdate_minus_one = (festival.startdate - 1) unless festival.nil?
	  if logged_in?
	  	@favourite_artist = Favourite.find_by(artist_id: artist.id, user_id: current_user.id)
	  end
	end
end