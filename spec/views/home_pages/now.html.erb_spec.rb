require 'rails_helper'

RSpec.describe "home_pages/now.html.erb", :type => :view do
	context "Heading" do
	  before(:example) do
			assign(:performances, [])
			assign(:dayindex, 2)
	  end
	  it "has title" do
	  	render
	  	assert_select "h5","Now Playing"
	  end
	  it "has date as a title" do
	  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
	  	render 
	  	expect(rendered).to match /Sun 20 Mar 2016 12:07 PM/
		end
		it "has day number " do
	  	assign(:dayindex, 2)
	  	render 
	  	expect(rendered).to match /Day: 2/
		end
		it "has an invalid day number " do
	  	assign(:dayindex, 0)
	  	render 
	  	expect(rendered).to_not match /Day: 0/
		end
		
		it "has a panel" do
			render
		 	assert_select "div.panel",1
		end
		it "has refresh button" do
			render
			assert_select "a","Refresh"
			assert_select "a[href=?]", "/now"
		end
		it "has next button" do
			render
			assert_select "a","Next"
			assert_select "a[href=?]", "/next"
		end
		it "has a nobody there yet message" do
			render
			expect(rendered).to match /Nobody on stage yet/
		end
	end
	context "performances" do
		it "shows a performance and stage record" do
			assign(:dayindex, 3)		
			p = create(:performance_with_festival)
			performances = Performance.select("performances.duration,performances.starttime,performances.title as caption, artist_id, stages.id, stages.code,stages.title").joins("inner join stages on performances.stage_id = stages.id").where("performances.id = ?",p.id).all
			assign(:performances,performances)
			render
			assert_select "table.table",1
			assert_select "td", {:text => "Mojo", :count => 1}
			assert_select "td[2]", {:text => "19:15", :count => 1}
			assert_select "td[3]", {:text => "performance caption", :count => 1}
			assert_select "td[4]", {:text => "(60 mins)", :count => 1}
		end
	end
end
