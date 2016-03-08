# == Schema Information
#
# Table name: artistpages
#
#  id          :integer          not null, primary key
#  letterstart :string
#  letterend   :string
#  title       :string
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :artistpage do
    letterstart "a"
    letterend "b"
    title "A-B"
    seq 1
    festival nil
  end
  factory :festival_with_artist_page,  class: Festival do
  	startdate "2016-04-01"
    days 5
    scheduledate "2016-01-28"
    year "2016"
    title "Bluesfest"
    major 1
    minor 2
    active true
		factory :festival_with_artist_pages do
	    ignore do
		    pages [{letterstart: "0",letterend: "b",title: "A-B", seq: 1},
					{letterstart: "c",letterend: "e",title: "C-E", seq: 2 },	    						
					{letterstart: "f",letterend: "i",title: "F-I", seq: 3},	    						
					{letterstart: "j",letterend: "l",title: "J-L", seq: 4},	    						
					{letterstart: "m",letterend: "p",title: "M-P", seq: 5},	    						
					{letterstart: "r",letterend: "s",title: "R-S", seq: 6},	    						
					{letterstart: "t",letterend: "tm",title: "Ta-Tm", seq: 7},	    			
					{letterstart: "tn",letterend: "z",title: "Tn-Z", seq: 8},	    									
					]
				page_count 8
			end
			after(:create) do |festival, evaluator|   	
	    	evaluator.pages.first(evaluator.page_count).each do |page|
	    		
					create(:artistpage,festival_id: festival.id, letterstart: page[:letterstart], letterend: page[:letterend], title: page[:title], seq: page[:seq])
				end
			end
		end
		factory :festival_with_artist_and_page do
			after(:create) do |festival, evaluator|   	
	    	create(:artistpage,festival_id: festival.id, letterstart: 'a', letterend: 'y', title: 'everything', seq: 1)
	    	create(:artist, festival_id: festival.id, active: true)
			end
		end      
      
	end
end
