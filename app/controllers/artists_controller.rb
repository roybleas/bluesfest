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
  	@artists = Artist.current_active_festival.order(name: :desc).all
  end

  def show
  	artist_id = params[:id].to_i
  	@artist = Artist.current_active_festival.find_by_id(artist_id)
  end
end
