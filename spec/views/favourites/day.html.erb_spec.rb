require 'rails_helper'

RSpec.describe "favourites/day.html.erb", :type => :view do
	describe "heading" do
  	before(:example) do
  		assign(:festivaldays,5)
  		assign(:performances, [])
  	end
		it "has links for number of festival days" do
			render
			assert_select "a[href=?]", "/favourites/day/1"
			assert_select "a[href=?]", "/favourites/day/5"
			assert_select "a", "Day 5"
		end
		it "has the date of the scheduled day" do
			assign(:dayindex, 1)
			assign(:dayindex_as_date, "My schedule for Day: 1 ( Thu 24 March 2016 )")
			render
			expect(rendered).to include "My schedule for Day: 1 ( Thu 24 March 2016 )"
		end
		it "has no festival day links when festival not set" do
			assign(:festivaldays,0)
			render
			assert_select "a", { :text => "Day 1" , :count => 0}
		end
		
		it "has day link for day index set to active " do
			assign(:dayindex, 1)
			render
			assert_select "a.btn-primary", 1
		end		
	end
	describe "no performances" do
		it "shows a no performances message" do
			assign(:festivaldays,5)
			assign(:performances, [])
			render
			expect(rendered).to include "No performances selected"
		end
	end
	describe "table of performances" do
  	before(:example) do
  		assign(:festivaldays,5)
  		@s1 = create(:stage)
  		@a1 = create(:artist)
  		p1 = build(:performance,stage_id: @s1.id, artist_id: @a1.id, title: "Tom Jones")	
  		assign(:performances,[p1])
  		assign(:dayindex, 1)
  	end

		it "has a table without header for performances" do
			render 
			assert_select "table.table", {:count => 1}
		end
		it "has stage title in first column" do
			render
			assert_select "tbody tr td" , @s1.title
		end
		
		it "has stage color code" do
			render
			assert_select "td.mo", {:count => 1}
		end
		
		it "has link to favouites" do
			render
			assert_select "a","Favourites"
			assert_select "a[href=?]", "/favourites"
		end
		
		it "has performance time, caption, and duration " do
			render
			expect(rendered).to include "19:15"
			expect(rendered).to include "Tom Jones"
			expect(rendered).to include "(60 mins)"
		end
		
	end
end
