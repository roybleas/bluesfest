require './app/services/extract_performances_service.rb'


namespace :extract do
  desc "performances from schedule to csv file "
  task performances: :environment do
    
    puts "extract performances"
    
  	filesuffix = "160302"
  	filename = "schedule#{filesuffix}.txt"
  	file = Rails.root.join('extract',filename)
  	
		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)  
		currentFestival.load	
		currentFestival.output_festival_message
  	
  	puts "extracting..."
  	
  	performances = ExtractPerformances.new(currentFestival.festival)
  	
  	performance_array = performances.process_file(file)
  	
  	if performance_array.empty?	
  		puts "no performances extracted"
  	else
  		filename = "schedule#{filesuffix}.csv"
  		filecsv = Rails.root.join('db','dbloadfiles',filename)

			CSV.open(filecsv, 'w') do |csv_object|
  			performance_array.each do |row|
    			csv_object << row
    		end
  		end
		end
  end

end
