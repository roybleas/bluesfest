require 'csv'


class LoadArtistPages
	
	def initialize(filename, currentfestival)
			@file_pathname = filename
			@currentfestival = currentfestival
	end
	
	def load
		
		remove_existing_pages(@currentfestival)
		
		festival = @currentfestival
		
		add_count = 0
		
		CSV.foreach(@file_pathname, {headers: :true}) do |row|
			#letterstart,letterend,title,seq
			
			letter_start = row["letterstart"].strip
			letter_end = row["letterend"].strip
			title = row["title"].strip
			seq = row["seq"].strip.to_i
									
			page = Artistpage.new
			page.letterstart 	= letter_start
			page.letterend 		= letter_end
			page.title 				= title
			page.seq 					= seq
			page.festival_id = festival.id
			page.save
			add_count += 1
		end
		puts "Added: #{add_count} Artist pages"
	end
	
	def remove_existing_pages(festival)
		
		Artistpage.where('festival_id = ?', festival.id).delete_all unless festival.nil?
		 
	end
end