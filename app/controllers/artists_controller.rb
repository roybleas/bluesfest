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
  	end
  end
  
  def bypage
  	@page = range_page(params[:letter])
  	page_range = verify_range(@page)
  	@artists = get_artists_by_range(page_range)
  	@pages = Artistpage.current_active_festival.all.order(seq: :asc)
	end
	
	private
	
	def range_page(letter)
		letter.downcase!
		
		searchby = {letter: letter}
		page = Artistpage.current_active_festival.by_letter(searchby).take
		if page.nil?
			searchby = {letter: 'a'}
			page = Artistpage.current_active_festival.by_letter(searchby).take
		end
		
		return page
	end
	
	def verify_range(page)	

		if not page.nil?
  	 
	  	letter_end = page.letterend == 'z' ? nil : page.letterend.next	
	  	letter_start = page.letterstart
	  	
	  	page_range = {letterstart: letter_start, letterend: letter_end}
	  	
	  end
	  
	  return page_range
	end
	
	def get_artists_by_range(page_range)

		return Artist.current_active_festival.all if page_range.nil?
	
		if page_range[:letterend].nil?
			artists = Artist.current_active_festival.starting_with_letter(page_range[:letterstart]).order(name: :asc).all 
		else
			artists = Artist.current_active_festival.by_letter_range(page_range[:letterstart], page_range[:letterend]).order(name: :asc).all
		end
  	
  	return artists
	end	
end
