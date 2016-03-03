# == Schema Information
#
# Table name: stages
#
#  id          :integer          not null, primary key
#  title       :string
#  code        :string(2)
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    title "Mojo"
    code 'mo'
    seq 1
    festival nil
   	
   	factory :stage_with_festival, class: Stage do
  		festival
  	end
  end
  factory :festival_with_stage,  class: Festival do
  	startdate "2016-04-01"
    days 5
    scheduledate "2016-01-28"
    year "2016"
    title "Bluesfest"
    major 1
    minor 2
    active true
    
    factory :festival_with_stages do
	    ignore do
	    	stages  [{title: "Mojo",	      code: "mo", seq: 1},
	    						{title: "Crossroads",	code: "cr", seq: 2},
	    						{title: "Delta",	    code: "de", seq: 3},
	    						{title: "Jambalaya",	code: "ja", seq: 4},
	    						{title: "Juke Joint",	code: "ju", seq: 5}
	    						]
	    	stage_count  5
	    end
	    
	    after(:create) do |festival, evaluator|
	    	
	    	evaluator.stages.first(evaluator.stage_count).each do |s|
	    		create(:stage, festival: festival, title: s[:title], code: s[:code], seq: s[:seq])
				end
			end
		end
		factory :festival_with_stages_random_order do
	    ignore do
	    	stages  [
	    						{title: "Jambalaya",	code: "ja", seq: 4},
	    						{title: "Crossroads",	code: "cr", seq: 2},
	    						{title: "Juke Joint",	code: "ju", seq: 5},
	    						{title: "Delta",	    code: "de", seq: 3},
	    						{title: "Mojo",	      code: "mo", seq: 1}
	    						]
	    end
	    
	    after(:create) do |festival, evaluator|
	    	evaluator.stages.each do |s|
	    		create(:stage, festival: festival, title: s[:title], code: s[:code], seq: s[:seq])
				end
			end
		end
		
		factory :festival_with_stages_and_performances do
	    ignore do
	    	stages  [{title: "Mojo",	      code: "mo", seq: 1},
	    						{title: "Crossroads",	code: "cr", seq: 2},
	    						{title: "Delta",	    code: "de", seq: 3},
	    						{title: "Jambalaya",	code: "ja", seq: 4},
	    						{title: "Juke Joint",	code: "ju", seq: 5}
	    						]
	    	stage_count  5
	    	performance_count 1
	    	day_count 1
	    	time_difference_mins 0
	    end
	    
	    after(:create) do |festival, evaluator|
	    	count = 0
	    	evaluator.stages.first(evaluator.stage_count).each do |s|
	    		
	    		time_start = Time.now.utc.change({hour: 14}) + (count * evaluator.time_difference_mins).minutes
	    		count += 1
	    		s = create(:stage, festival: festival, title: s[:title], code: s[:code], seq: s[:seq])
	    		(1..evaluator.day_count).each do |count| 
		    		(1..evaluator.performance_count).each do 
		    			a = create(:artist_sequence,festival: festival)
		    			if evaluator.time_difference_mins == 0
		    				p = create(:performance,festival: festival, artist_id: a.id, stage_id: s.id, daynumber: count)
		    			else
		    				p = create(:performance,festival: festival, artist_id: a.id, stage_id: s.id, daynumber: count, starttime: time_start)
		    				time_start = time_start + evaluator.time_difference_mins.minutes
		    			end
		    		end
		    	end
				end
			end
		end
		
	end
	
end
