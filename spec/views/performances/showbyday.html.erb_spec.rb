require 'rails_helper'
require 'htmlentities'


RSpec.describe "performances/showbyday.html.erb", :type => :view do
	htmlcoder = HTMLEntities.new
	
  it "shows no performances message" do
  	assign(:performances,[])
  	assign(:dayindex, 2)
  	assign(:stages,[])
  	render 
  	expect(rendered).to match /No performances for day 2/
  end
  it "shows no stages message" do
		p = build(:performance)
		assign(:performances,[p])
		assign(:stages,[])
  	render 
  	expect(rendered).to match /No stage information available/
  end
  
  context "days navigation menu" do
  	before(:each) do
  		p = build(:performance_with_artist_and_stage)
  		assign(:performances,[p])
  		s = p.stage
  		assign(:stages,[s])
  	end
  	it "shows no Day pages if festival days not set" do
  		assign(:festivaldays, 0)
  		assign(:dayindex, 1)
  		render
  		assert_select "li", 2
  	end	
  	it "shows links for 2 days and link" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 2)
  		render
  		assert_select "ul" do
    		assert_select "li", 4 do
    			assert_select "a", 4
    		end
  		end 
		end
		it "shows link for each festival day" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 4)
  		render
    	assert_select "li", 6
		end
		it "shows index day page navigation as active " do
			assign(:dayindex, 2)
  		assign(:festivaldays, 3)
  		render
  		assert_select "li.active", { :count => 1 }
  		assert_select "li.active a",  "Day 2"
  	end
  	it "has pagination link" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 3)
  		render
  		assert_select "li a[href=?]", "/showbyday/1"
		end
		it "has disabled First link when first day index" do
			assign(:dayindex, 1)
  		assign(:festivaldays, 2)
  		render
  		assert_select "li.disabled", {:count => 1}
  		assert_select "li.disabled a span", htmlcoder.decode("&laquo;")  		
  	end
		it "has disabled last link when last day index" do
			assign(:dayindex, 2)
  		assign(:festivaldays, 2)
  		render
  		assert_select "li.disabled", {:count => 1}
  		assert_select "li.disabled a span", htmlcoder.decode("&raquo;")
  	end
  end
	context "header" do
		it "shows performances for Day: number" do
  		p = build(:performance_with_artist_and_stage)
  		assign(:performances,[p])
			assign(:dayindex, 2)
			assign(:performancedate, "Sun 4 April 2016")
			assign(:festivaldays, 3)
			s = p.stage
			assign(:stages,[s])
			render
			expect(rendered).to match /Performances for Day: 2 (Sun 4 April 2016)/
		end
	end
	context "schedule" do
		context "header" do
	  	before(:each) do
	  		p = build(:performance_with_artist_and_stage)
	  		s = p.stage
	  		stage2 = build(:stage, title: "Crossroads", code: "cr")
	  		assign(:stages,[s,stage2])
  			assign(:performances,[p])
  			assign(:dayindex, 2)
  			assign(:festivaldays, 3)
  		end

			it "has a header with column start time" do
				render
				assert_select "thead tr td", 'Start Time'
			end	
			it "has stage column headers" do
				render
				assert_select "thead tr" do
					assert_select "td", 'Mojo'
					assert_select "td", 'Crossroads'
				end
			end
			it "has stage headers with stage class code" do
				render
				assert_select "thead tr" do
					assert_select "td.mo", {:count => 1}
					assert_select "td.cr", {:count => 1}
				end
			end
		end
		context 'list performance' do
			before(:each) do
				festival = FactoryGirl.create(:festival_with_stages_and_performances, stage_count: 3, performance_count: 1)
				@performances = Performance.for_day(1).includes(:artist).for_festival(festival).order(starttime: :asc).all
				assign(:performances,@performances)
  			assign(:dayindex, 1)
  			assign(:festivaldays, festival.days)
  			assign(:stages,Stage.by_festival(festival).order(seq: :asc).all)
			end
			it "shows time for a performance" do
				render
				assert_select "tbody tr td", "19:15"
			end
			it "shows artist for one performance in Mojo" do
				p = @performances[0]
				render
				assert_select "tbody tr td", p.artist.name
			end
			it "shows the stage class code for the cell" do
				render
				assert_select"tbody tr td.mo", {:count => 1 }
			end
		end
		context 'list performance on multiple rows' do
			before(:each) do
				festival = FactoryGirl.create(:festival_with_stages_and_performances, stage_count: 3, performance_count: 1)
				p = Performance.last
				p.update(starttime:  "20:00")
				@performances = Performance.for_day(1).includes(:artist).for_festival(festival).order(starttime: :asc).all
				assign(:performances,@performances)
  			assign(:dayindex, 1)
  			assign(:festivaldays, festival.days)
  			assign(:stages,Stage.by_festival(festival).order(seq: :asc).all)
			end
			
			it "starts a second row start time" do
				render
				
				assert_select "tr td", "20:00"
				assert_select "tbody", 1 do |body|
					body.each do |row|
						row.each do |element|
							assert_select element "td",4
							assert_select element "td", "20:00"
							assert_select element "td.de", 1
						end
					end
				end
			end
		end
	end
end
