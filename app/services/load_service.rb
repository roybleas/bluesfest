require 'csv'
require 'date'
require 'yaml'

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

class CurrentFestival
	attr_reader :title, :startdate
	
	def initialize(filename)
		@file_pathname = filename
	end
	
	def load
		begin
  		festival = YAML.load(File.open(@file_pathname))
  		@title = festival[0]['title']
  		@startdate = festival[0]['startdate']
  		output_festival_message
		end
	end
	
	def festival
		if @title.nil? || @startdate.nil?
			puts "Error: No current festival data set"
		else
			this_festival = Festival.where("festivals.startdate = ? and festivals.title = ?",@startdate,@title).take
			return this_festival
		end
	end

private
	def output_festival_message
		puts "Loading for #{@title} at #{@startdate} ..."
	end	
end

class ArtistCode
	class << self
		def extract(artistname)
			artistname.gsub(/[ \&\'\,\"\.]/,"").downcase
		end
	end
end

class LoadArtistError < StandardError
end


class LoadArtists
	
	def initialize(filename, currentfestival)
			@file_pathname = filename
			@currentfestival = currentfestival
	end
	
	def load
		artist_add_count = 0
		artist_update_count = 0
		
		festival = @currentfestival.festival
		raise LoadArtistError,  "Festival database record not found" if festival.nil?
		
		extract_date = getValidExtractDate

		CSV.foreach(@file_pathname, {col_sep: "\t", headers: :true}) do |row|
			
			artist_linkid = row["id"].strip
			artist_name = row["artist"].strip
			artist_code = ArtistCode.extract(artist_name)
			
			#skip the first line info
			next if artist_linkid == "ExtractDate"
	
			artist = Artist.by_code_and_festival_id(artist_code,festival.id).take		
			if artist.nil?
				artist = Artist.new
				
				artist.code = artist_code
				artist.festival_id = festival.id
				artist_add_count += 1
			else
				artist_update_count += 1
			end
			artist.name = artist_name
			artist.linkid = artist_linkid
			artist.active = true
			artist.extractdate = extract_date
			
			artist.save
		end
		puts "Added: #{artist_add_count} and updated: #{artist_update_count} artists"
		
	end
	 
	private
	
	def getValidExtractDate
		
		f = File.open(@file_pathname)
		csv = CSV.new(f, {col_sep: "\t", headers: :true})
		
		first_line = csv.gets
		f.close
		
		raise LoadArtistError, "Missing artist file extract date" unless first_line['id'].strip == "ExtractDate"
		begin
			dt = Date.parse(first_line['artist'].strip)
		rescue ArgumentError => e
			raise LoadArtistError, "Invalid extract date in artist file" unless e.message.match(/invalid date/).nil?
			raise  
		end
		
		return dt
	end
			

end