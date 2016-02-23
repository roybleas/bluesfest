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

  def index
  	@artists = Artist.current_active_festival.order(name: :asc).all
  end

  def show
  	artist_id = params[:id].to_i
  	@artist = Artist.find_by_id(artist_id)
  	@performances = Performance.for_artist(artist_id).includes(:stage).all
  	festival = Festival.find_by_id(@artist.festival_id)
  	@startdate_minus_one = (festival.startdate - 1) unless festival.nil?
  end
end
