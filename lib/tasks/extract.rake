require './app/services/extract_performances_service.rb'


namespace :extract do
  desc "performances from schedule to csv file "
  task performances: :environment do
    
    puts "extract performances"
    
    filename = 'performance_config.yml'
  	filePerformanceConfig = Rails.root.join('db','dbloadfiles',filename)
  	config = ConfigurationForExtract.new(filePerformanceConfig)

  	filename = "schedule#{config.file_suffix}.txt"
  	file = Rails.root.join('extract',filename)
  	
		filename = 'festival.yml'
  	fileCurrentFestival = Rails.root.join('db','dbloadfiles',filename)

		currentFestival = CurrentFestival.new(fileCurrentFestival)  
		currentFestival.load	
		currentFestival.output_festival_message
  	
  	puts "extracting..."
  	
  	performances = ExtractPerformances.new(currentFestival.festival)
  	performances.performance_data_format = config.performance_data_format
  	
  	performance_array = performances.process_file(file)
  	
  	if performance_array.empty?	
  		puts "no performances extracted"
  	else
  		filename = "schedule#{config.file_suffix}.csv"
  		filecsv = Rails.root.join('db','dbloadfiles',filename)

			CSV.open(filecsv, 'w') do |csv_object|
  			performance_array.each do |row|
    			csv_object << row
    		end
  		end
		end
  end

end
