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
	
