class ArtistsController < ApplicationController

  def index
  	@artists = Artist.current_active_festival.order(name: :desc).all
  end

  def show
  	artist_id = params[:id].to_i
  	@artist = Artist.current_active_festival.find_by_id(artist_id)
  end
end
