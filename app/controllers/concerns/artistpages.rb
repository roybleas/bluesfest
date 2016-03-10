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
	

end