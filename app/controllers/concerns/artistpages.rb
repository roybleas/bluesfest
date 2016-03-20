module Artistpages
	extend ActiveSupport::Concern
	
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
	
	def create_artists_list_by_page(letter,user_id)
	
	  festival = Festival.current_active.take
  	@page = range_page(letter)
  	page_range = verify_range(@page)
  	
  	if festival.nil?
  		@artists = []
  		@pages = []
  	else
  		@artists = get_artists_by_range(page_range, user_id,festival)  	
  		@pages = Artistpage.current_active_festival.all.order(seq: :asc)
  	end

	end
	
	def get_artists_by_range(page_range,user_id, festival)
		
		subquery = Favourite.where('favourites.user_id = ?', user_id)
		
		main_query = Artist.select_with_fav_user_id.from(subquery,:fav).joins_favourites.by_festival(festival).active_artist
		
		main_query = main_query.artists_by_range(page_range) if not page_range.nil?
		
		main_query = main_query.order(name: :asc).all
		
		return main_query
	end	

end