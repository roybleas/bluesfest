class SelectFestival
	def initialize(args)
		@year = args[:year].strip
	end
	def select_records
		Festival.where("festivals.year = ? ", @year).all
	end

end
class FestivalShow < SelectFestival
	def initialize(args)
		@year = args[:year].strip
		super(args) 
	end
	
	def run
		puts "For #{@year} the following records found:"
		festival_list = select_records
		festival_list.each do |f|
			puts "#{f.title} #{f.year} #{f.startdate}"
		end
	end
end
		
class FestivalDelete < SelectFestival
	def initialize(args)
		@year = args[:year].strip
		super(args) 
	end
	
	def run
		puts "Deleting records for #{@year}:"
		festival_list = select_records
		festival_list.each do |f|
			f.destroy 
		end
	end
end
	
class FavouritesShow
  def run
    fav_count = Favourite.count
    fav_perform_count = Favouriteperformance.count
    puts "There #{'is'.pluralize(fav_count)} #{fav_count} favourite artist #{'record'.pluralize(fav_count)} to delete "\
    "and there #{'is'.pluralize(fav_perform_count)} #{fav_perform_count} favourite performance #{'record'.pluralize(fav_perform_count)} to delete."
   end
end

class FavouritesDelete
  def run
    FavouritesShow.new().run
    puts "Deleting favourites"
    Favouriteperformance.delete_all
    Favourite.delete_all
  end
end