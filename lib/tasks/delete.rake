require './app/services/delete_records_service.rb'

namespace :delete do
  desc "Deletes festival records for a particular year "
  task :festival, [:year] => :environment do |t, args|
 
		year = args[:year].strip.downcase
		
		festival_delete = FestivalDelete.new(year: year)
		festival_delete.run
		
  end


end
