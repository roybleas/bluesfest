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
		currentFestival.output_festival_message


  	puts "uploading..."
  	loader = LoadArtists.new(file, currentFestival)

  	loader.load

  end

  desc "Upload stage data to database"
  task stages: :environment do
  	puts "upload stages"
  	filename = 'stages.csv'
  	file = Rails.root.join('db','dbloadfiles',filename)

		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)
		currentFestival.load
		currentFestival.output_festival_message

  	puts "uploading..."
  	loader = LoadStages.new(file, currentFestival)

  	loader.load

  end

  desc "Upload performances data to database"
  task performances: :environment do
  	puts "upload performances"
  	suffix = "180315"
  	filename = "schedule#{suffix}.csv"
  	file = Rails.root.join('db','dbloadfiles',filename)

		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)
		currentFestival.load
		currentFestival.output_festival_message

		performance_array = CSV.read(file,{headers: true})

		validateCodes = ValidateCodes.new(currentFestival.festival)
  	artistcodelist = validateCodes.artist_code_list(performance_array)
  	if validateCodes.artists(artistcodelist)
  		puts "All artist codes pre-loaded"

	  	stagecodelist = validateCodes.stage_code_list(performance_array)
	  	if validateCodes.stages(stagecodelist)
	  		puts "All stage codes pre-loaded"

  				loader = LoadPerformances.new(file,currentFestival.festival)
  				schedulecode = loader.load
  				puts "Loaded performances"
  				if not schedulecode.nil?
  					loader.remove_old_performances(schedulecode)
  					loader.update_artists_to_active
  					puts "Updated performances and artists"
  				end

  		end
  	end

  end

	desc "Upload artists page ranges to database"
  task artistpages: :environment do
  	puts "upload artist pages"
  	filename = 'artistpages.csv'
  	file = Rails.root.join('db','dbloadfiles',filename)

		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)
		currentFestival.load
		currentFestival.output_festival_message


  	puts "uploading..."
  	loader = LoadArtistPages.new(file, currentFestival.festival)

  	loader.load

  end


end
