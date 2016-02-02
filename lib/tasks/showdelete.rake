require './app/services/delete_records_service.rb'

namespace :showdelete do
  desc "Shows records to be deleted for a particular year "
  task :festival, [:year] => :environment do |t, args|
   	
		year = args[:year].strip.downcase
		
		festival_show = FestivalShow.new(year: year)
		festival_show.run
		
  end

  desc "TODO"
  task artists: :environment do
  end

end
