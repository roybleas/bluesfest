require 'csv'
require 'date'

class LoadFestival
	def initialize(filename)
			@file_pathname = filename
	end
		
	def load
		
		CSV.foreach(@file_pathname, {headers: :true}) do |row|
			
			festival_year = row["year"].strip
			
			festival = Festival.find_or_create_by(year: festival_year )
			festival.startdate = Date.parse(row["startdate"])
			festival.days = row["days"].to_i
			festival.scheduledate = Date.parse(row["scheduledate"])
			festival.year = festival_year
			festival.title = row["title"].strip
			festival.major = row["major"].to_i
			festival.minor = row["minor"].to_i
			festival.active = row["active"].strip.to_bool
						
			festival.save
			puts "Loaded festival #{festival.title} for #{festival.year}"
		end
		
	end
end