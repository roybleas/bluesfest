require 'rails_helper'

RSpec.describe "favourites/index.html.erb", :type => :view do
  describe "heading" do
  	before(:example) do
  		assign(:festivaldays,5)
  	end
  	it "has a title" do
  		render
	  	assert_select "h2", "Favourites" 
		end	
		it "has a link to add favourite artists" do
			render
			assert_select "a[href=?]", "/favourites/add/a" 
			assert_select "a", { :text => "Select Artists" , :count => 1}
			assert_select "a.btn","Select Artists"
		end
		it "has links for number of festival days" do
			render
			assert_select "a[href=?]", "/favourites/day/1"
			assert_select "a[href=?]", "/favourites/day/5"
			assert_select "a", "Day 5"
		end
	end
	describe "peformances " do
  	before(:example) do
  		user = create(:user_for_favourites_with_performances_and_stage)
  		assign(:festivaldays,5)
  		favourites = Favourite.for_user(user).includes(:artist, favouriteperformances: { performance: :stage } ).order("artists.name, performances.daynumber asc").all
			assign(:favourites,favourites)
			
  	end
		it "shows table " do
			render
			assert_select "table.table-bordered", {:count => 1}
		end	
		it "has day column headers" do
			render
			assert_select "thead tr" do
				assert_select "td", 'Artist'
				assert_select "td", 'Day 1'
				assert_select "td", 'Day 2'
			end
		end

		it "shows artist" do
			render
			assert_select "tr td", 'Tom Jones'
			assert_select "tbody", 1 do |body|
				body.each do |row|
					row.each do |element|
						assert_select element "td",   6
						assert_select element "td",   "Tom Jones"
						assert_select element "td",   "17:15"
						assert_select element "td.mo", 3
					end
				end
			end
		end		
	end
end
