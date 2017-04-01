require './app/services/delete_records_service.rb'

namespace :delete do
  desc "Deletes festival records for a particular year "
  task :festival, [:year] => :environment do |t, args|
 
		year = args[:year].strip.downcase
		
		festival_delete = FestivalDelete.new(year: year)
		festival_delete.run
		
  end

  desc "Deletes all favourite and favourite performance records"
  task :favourites, [:dry] => :environment do |t, args|
 
		dryrun = args[:dry].to_s
		if dryrun.match(/dry/) 
		  FavouritesShow.new().run
		else
		  FavouritesDelete.new().run
		end
		
  end

end
