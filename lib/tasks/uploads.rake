require './app/services/load_service.rb'

namespace :uploads do
  desc "Upload festival data to database"
  task festival: :environment do |t, args|
  
  	puts "upload festivals"
  	filename = 'festivals.csv'
  	file = Rails.root.join('db','dbloadfiles',filename)
  	
  	
  	if File.exists?(file)
  		puts "file found - uploading..."
  		loader = LoadFestival.new(file)
  		loader.load
  	else
  		puts "File not found: #{file}"
  	end
  end

  desc "Upload artists data to database"
  task artists: :environment do
  	puts "upload artists"
  	filename = 'artists.csv'
  	file = Rails.root.join('db','dbloadfiles',filename)
  	
		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)  
		currentFestival.load	
  	
  	
  	puts "uploading..."
  	loader = LoadArtists.new(file, currentFestival)
  		
  	loader.load
  	
  	
  end

end
